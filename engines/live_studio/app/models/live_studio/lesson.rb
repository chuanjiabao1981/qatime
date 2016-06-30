module LiveStudio
  class Lesson < ActiveRecord::Base
    has_soft_delete

    enum status: {
      init: 0, # 初始化
      ready: 1, # 等待上课
      teaching: 2, # 上课中
      finished: 3, # 已完成
      completed: 4 # 已结算
    }

    default_scope { order("id asc") }
    scope :unfinish, -> { where("status < ?", Lesson.statuses[:finished]) }

    belongs_to :course
    belongs_to :teacher, class_name: '::Teacher' # 区别于course的teacher防止课程中途换教师

    has_many :play_records # 听课记录
    has_many :billings, as: :target, class_name: 'Payment::Billing' # 结算记录

    validates :name, :description, :course_id, :start_time, :end_time, :class_date, presence: true

    include AASM

    aasm column: :status, enum: true do
      state :init, initial: true
      state :ready
      state :teaching
      state :finished
      state :completed

      event :teach do
        before do
          course.teaching! if course.preview?
          self.live_start_at = Time.now
        end
        transitions from: :ready, to: :teaching
      end

      event :finish do
        before do
          self.teacher_id = course.teacher_id
          # TODO 需要改成付费听课人数
          self.live_count = play_records.count # 听课人数
          self.live_end_at = Time.now
          self.real_time = ((live_end_at - live_start_at) / 60.0).ceil # 实际直播时间
        end

        after do
          expire_taste_tickets # 过期试听证
          complete!
        end
        transitions from: :teaching, to: :finished
      end

      event :complete do
        before do
          # 本次课程学费
          # 根据学生单次课程成本价计算
          money = course.buy_tickets.sum(:lesson_price)
          billing = billings.create(total_money: money, summary: "课程完成结算, 结算金额: #{money}")
          Payment::CashAccount.transaction do
            # 系统支出
            decrease_cash_admin_account(money)
            # 系统收取佣金
            money -= system_fee!(money, billing)
            # 教师分成
            money -= teacher_fee!(money, billing)
            # 代理商分成
            manager_fee!(money, billing)
          end
        end
        transitions from: :finished, to: :completed
      end
    end

    def can_play?
      ready? || teaching?
    end

    def has_finished?
      self[:status] > Lesson.statuses[:teaching]
    end

    # 是否可以准备上课
    def ready_for?
      init? && class_date == Date.today
    end

    def short_description(len = 20)
      description.try(:truncate, len)
    end

    private

    # 过期试听证
    def expire_taste_tickets
      course.taste_tickets.used.map(&:expired!)
    end

    # 系统服务费
    def system_fee!(money, billing)
      system_money = Course::SYSTEM_FEE * live_count * real_time
      system_money = money if system_money > money
      increase_cash_admin_account(system_money)
      billing.billing_items.create(account: CashAdmin.current, total_money: system_money, summary: "课程-#{name}-#{id}完成,系统服务费#{system_money}")
      system_money
    end

    # 教师分成
    def teacher_fee!(money, billing)
      teacher_money = money * course.teacher_percentage / 100
      teacher.cash_account!.increase(teacher_money, self, "课程完成 - #{id} - #{name}")
      billing.billing_items.create(account: teacher, total_money: teacher_money, summary: "课程-#{name}-#{id}完成,教师提成#{teacher_money}")
      teacher_money
    end

    # 代理商分成
    # 代理商的分成打入workstation账户下
    def manager_fee!(money, billing)
      course.workstation.cash_account!.increase(money, self, "课程完成 - #{id} - #{name}")
      billing.billing_items.create(account: course.workstation, total_money: money, summary: "课程-#{name}-#{id}完成,代理商提成#{money}")
    end

    # 结算完成后
    # 系统账户 支出结算金额
    def decrease_cash_admin_account(money, billing)
      CashAdmin.decrease_cash_account(money, billing, '课程完成 - 支出结算')
    end

    # 结算完成后
    # 系统账户 收取服务费
    def increase_cash_admin_account(money, billing)
      CashAdmin.increase_cash_account(money, billing, '课程完成 - 系统服务费')
    end
  end
end
