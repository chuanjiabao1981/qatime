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

    # default_scope { order("id asc") }
    scope :unfinish, -> { where("status < ?", Lesson.statuses[:finished]) }
    scope :should_complete, -> { where("status = ? and (? - live_start_at) > interval '1 hour'", Lesson.statuses[:teaching],Time.now)}
    scope :teached, -> { where("status > ?", Lesson.statuses[:teaching]) } # 已经完成上课
    scope :today, -> { where(class_date: Date.today) }

    belongs_to :course
    belongs_to :teacher, class_name: '::Teacher' # 区别于course的teacher防止课程中途换教师

    has_many :play_records # 听课记录
    has_many :billings, as: :target, class_name: 'Payment::Billing' # 结算记录

    has_many :live_sessions # 直播 心跳记录

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
      # 如果角色是学生,则显示的状态不一样,如下:
      # 未开课(还没有到上课日期)
      # 等待直播(今天的课程还没有开始直播)
      # 正在直播
      # 暂停直播(已经开始的直播10分钟没有收到心跳)
      # 结束直播(收到结束请求，或者被系统清理的辅导班)
      @role_status =
          if role == 'student'
            if class_date > Date.today
              'init'
            else
              case status
                when 'teaching'
                  ((last_heartbeat_at - live_start_at) / 60).ceil > 10 ? 'suspended' : 'teaching'
                when 'finished','billing','completed'
                  'closed'
              end
            end
          end
      @role_status = "student.#{@role_status}" if @role_status
      I18n.t("activerecord.status.live_studio/lesson.#{@role_status || status}")
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

    # 心跳
    def heartbeats(token=nil)
      @live_session = token.blank? ? new_live_session : current_live_session
      @live_session.heartbeat_count += 1
      @live_session.duration += 5
      @live_session.heartbeat_at = Time.now
      @live_session.save
      @live_session.token
    end

    def current_live_session
      live_sessions.last || new_live_session
    end

    def last_heartbeat_at
      current_live_session.heartbeat_at
    end

    def is_over?
      # todo 判断课程是否已经结束
      false
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

    def new_live_session
      live_sessions.create(
          token: Digest::MD5.hexdigest(Time.now.to_s).upcase,
          heartbeat_count: 0,
          duration: 0, # 单位(分钟)
          heartbeat_at: Time.now
      )
    end
  end
end
