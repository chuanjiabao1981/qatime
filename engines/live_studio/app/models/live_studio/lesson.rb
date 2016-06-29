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

    has_many :play_records #听课记录
    validates :name, :description, :course_id, :start_time, :end_time, :class_date, presence: true

    include AASM

    aasm :column => :status, :enum => true do
      state :init, :initial => true
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
          complete!
        end
        transitions from: :teaching, to: :finished
      end

      event :complete do
        before do
          # 本次课程学费
          # 根据学生单次课程成本价计算
          money = course.buy_tickets.sum(:lesson_price)
          CashAccount.transaction do
            money -= system_fee!(money) # 系统收取佣金
            money -= teacher_fee!(money) # 教师分成
            manager_fee!(money) # 代理商分成
          end
        end
        transitions from: :finished, to: :completed
      end
    end

    def can_play?
      ready? or teaching?
    end

    def has_finished?
      self[:status] > Lesson.statuses[:teaching]
    end

    # 是否可以准备上课
    def ready_for?
      init? && class_date == Date.today
    end

    def short_description(len=20)
      description.try(:truncate, len)
    end

    private

    # 系统服务费
    def system_fee!(money)
      system_money = Course::SYSTEM_FEE * live_count * real_time
      system_money = money if system_money > money
      system_money
    end

    # 教师分成
    def teacher_fee!(money)
      teacher_money = money * course.teacher_percentage / 100
      teacher.cash_account!.increase(teacher_money, self, "课程完成 - #{id} - #{name}")
      teacher_money
    end

    # 代理商分成
    # 代理商的分成打入workstation账户下
    def manager_fee!(money)
      course.workstation.cash_account!.increase(money, self, "课程完成 - #{id} - #{name}")
    end

  end
end
