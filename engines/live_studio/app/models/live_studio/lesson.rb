require 'encryption'
module LiveStudio
  class Lesson < ActiveRecord::Base
    has_soft_delete

    enum status: {
      init: 0, # 初始化
      ready: 1, # 等待上课
      teaching: 2, # 上课中
      paused: 3, # 暂停中 意外中断可以继续直播
      closed: 4, # 直播结束 可以继续直播
      finished: 5, # 已完成 不可继续直播
      billing: 6, # 结算中
      completed: 7 # 已结算
    }

    # default_scope { order("id asc") }
    scope :unfinish, -> { where("status < ?", Lesson.statuses[:finished]) } # 未完成的课程
    scope :unclosed, -> { where('status < ?', Lesson.statuses[:closed]) } # 未关闭的课程
    scope :unstart, -> { where('status < ?', Lesson.statuses[:teaching]) } # 未开始的课程
    scope :should_complete, -> { where(status: [statuses[:finished], statuses[:billing]]).where("class_date < ?", Date.yesterday)} # 可以completed的课程
    scope :teached, -> { where("status > ?", Lesson.statuses[:teaching]) } # 已经完成上课
    scope :today, -> { where(class_date: Date.today) }
    scope :since_today, -> {where('class_date > ?',Date.today)}
    scope :include_today, -> {where('class_date >= ?',Date.today)}
    scope :waiting_finish, -> { where(status: [statuses[:paused], statuses[:closed]])}
    scope :month, -> (month){where('class_date >= ? and class_date <= ?',month.beginning_of_month.to_date,month.end_of_month.to_date)}

    belongs_to :course
    belongs_to :teacher, class_name: '::Teacher' # 区别于course的teacher防止课程中途换教师

    has_many :play_records # 听课记录
    has_many :billings, as: :target, class_name: 'Payment::Billing' # 结算记录

    has_many :live_sessions # 直播 心跳记录

    validates :name, :course_id, :start_time, :end_time, :class_date, presence: true
    before_create :data_preview
    after_commit :update_course

    include AASM

    aasm column: :status, enum: true do
      state :init, initial: true
      state :ready
      state :teaching
      state :paused
      state :closed
      state :finished
      state :billing
      state :completed

      event :teach do
        # before do
        #   # 开始上课之前把辅导班设置为已开课
        #   course.teaching! if course.preview?
        #   # 记录上课开始时间
        #   self.live_start_at = Time.now if live_start_at.nil?
        #   # 开始上课之前把上一节未结束的课程设置为结束,并切不能继续直播
        #   course.lessons.waiting_finish.each do |lesson|
        #     lesson.finish! unless lesson.id == id
        #   end
        # end
        transitions from: :ready, to: :teaching
        transitions from: :paused, to: :teaching
        transitions from: :closed, to: :teaching
      end

      event :pause do
        transitions from: :teaching, to: :paused
      end

      event :close do
        transitions from: :teaching, to: :closed
        transitions from: :paused, to: :closed
      end

      event :finish do
        transitions from: :paused, to: :finished
        transitions from: :closed, to: :finished
      end

      event :complete do
        transitions from: :finished, to: :completed
        transitions from: :billing, to: :completed
      end
    end

    def status_text(role = nil,outer = true)
      role == 'teacher' || role = 'student'
      I18n.t("lesson_status.#{role}.#{status}#{!outer && status == 'paused' ? '_inner' : ''}")
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
    def heartbeats(token = nil)
      @live_session = token.blank? ? new_live_session : current_live_session
      @live_session.heartbeat_count += 1
      @live_session.duration += 5
      @live_session.heartbeat_at = Time.now
      @live_session.save
      self.heartbeat_time = Time.now
      teach if ready? || paused? || closed?
      save
      @live_session.token
    end

    def current_live_session
      live_sessions.last || new_live_session
    end

    def last_heartbeat_at
      current_live_session.heartbeat_at
    end

    def is_over?
      # 判断课程是否已经结束
      %w(closed finished billing completed).include?(status)
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
        token: ::Encryption.md5("#{self.id}#{Time.now}").downcase,
        heartbeat_count: 0,
        duration: 0, # 单位(分钟)
        heartbeat_at: Time.now
      )
    end

    def data_preview
      self.status = self.class_date == Date.today ? 1 : 0
    end

    def update_course
      first_class_date = course.lessons.order(:class_date).first.class_date
      course.update(class_date: first_class_date)
    end
  end
end
