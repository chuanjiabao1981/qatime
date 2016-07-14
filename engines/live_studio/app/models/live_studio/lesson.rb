module LiveStudio
  class Lesson < ActiveRecord::Base
    has_soft_delete

    enum status: {
      init: 0, # 初始化
      ready: 1, # 等待上课
      teaching: 2, # 上课中
      finished: 3, # 已完成
      billing: 4, # 结算中
      completed: 5 # 已结算
    }

    default_scope { order("id asc") }
    scope :unfinish, -> { where("status < ?", Lesson.statuses[:finished]) }
    scope :teached, -> { where("status > ?", Lesson.statuses[:teaching]) } # 已经完成上课
    scope :today, -> { where(class_date: Date.today) }

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
        transitions from: :teaching, to: :finished
      end

      event :complete do
        transitions from: :finished, to: :completed
        transitions from: :billing, to: :completed
      end
    end

    def status_text(role = nil)
      role_status = role == 'student' ? "#{role}.#{status}" : status
      I18n.t("activerecord.status.live_studio/lesson.#{role_status}")
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

    def live_time
      "#{start_time}~#{end_time}"
    end

    private

    # 过期试听证
    def used_taste_tickets
      course.taste_tickets.pre_used.map(&:used!)
    end

    # 系统服务费
    def system_fee!(money, billing)
      system_money = Course::SYSTEM_FEE * live_count * real_time
      system_money = money if system_money > money
      increase_cash_admin_account(system_money, billing)
      system_money
    end

    # 教师分成
    def teacher_fee!(money, billing)
      teacher_money = money * course.teacher_percentage.to_f / 100
      teacher.cash_account!.increase(teacher_money, billing, "课程完成 - #{id} - #{name} - #{teacher_money}/#{money}")
      teacher_money
    end

    # 代理商分成
    # 代理商的分成打入workstation账户下
    def manager_fee!(money, billing)
      course.workstation.cash_account!.increase(money, billing, "课程完成 - #{id} - #{name}")
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
