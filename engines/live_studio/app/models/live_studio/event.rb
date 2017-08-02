require 'encryption'
module LiveStudio
  class Event < ActiveRecord::Base
    has_soft_delete
    include AASM
    extend Enumerize

    delegate :teacher_percentage, :publish_percentage, :base_price, :workstation, :board_channel, :channels, to: :group

    has_many :live_sessions, as: :sessionable # 直播 心跳记录
    has_many :ticket_items, as: :target

    attr_accessor :_update

    enum status: {
      missed: -1, # 已错过
      init: 0, # 初始化
      ready: 1, # 等待上课
      teaching: 2, # 上课中
      paused: 3, # 暂停中 意外中断可以继续直播
      closed: 4, # 直播结束 可以继续直播
      finished: 5, # 已完成 不可继续直播
      billing: 6, # 结算中
      completed: 7 # 已结算
    }

    enumerize :duration, in: {
      minutes_30: 30,
      minutes_45: 45,
      hours_1: 60,
      hours_half_90: 90,
      hours_2: 120,
      hours_half_150: 150,
      hours_3: 180,
      hours_half_210: 210,
      hours_4: 240
    }, i18n_scope: "enumerize.live_studio/lessons.durations", scope: true, predicates: { prefix: true }

    belongs_to :group, counter_cache: true
    belongs_to :teacher, class_name: '::Teacher'

    scope :waiting_close, -> { where(status: statuses.values_at(:teaching, :paused)) }
    scope :unstart, -> { where('status < ?', statuses[:teaching]) } # 未开始的课程
    scope :today, -> { where(class_date: Date.today) }
    scope :readied, -> { where("status >= ?", statuses[:ready])} # 已就绪

    # 开始时间
    def start_time
      start_at.try(:strftime, '%H:%M')
    end

    # 结束时间
    def end_time
      end_at.try(:strftime, '%H:%M')
    end

    def live_time
      "#{start_time}-#{end_time}"
    end

    def status_text(role = nil, outer = true)
      role == 'teacher' || role = 'student'
      I18n.t("lesson_status.#{role}.#{status}#{!outer && status == 'paused' ? '_inner' : ''}")
    end

    # 判断课程是否未开始
    # 待补课, 初始化, 待上课算作没开始
    def unstart?
      %w(missed init ready).include?(status)
    end

    # 没开始课程算作没有结束
    # 暂停中或者上课中算作没有结束
    # 结束以后重新开始算作已经结束
    # 结束以后重新开始然后暂停算作已结束
    def unclosed?
      unstart? || %w(teaching paused).include?(status)
    end

    def had_closed?
      %w(closed finished billing completed).include?(status)
    end

    # 尚未直播
    def status_wating?
      %w[missed init ready].include?(status)
    end

    # 正在直播
    def status_living?
      %w[teaching paused].include?(status)
    end

    # 是否可以直播
    def can_live?
      ready? || paused? || closed?
    end

    def heartbeats(t, step, token = nil)
      live_session = session_by_token(token)
      return live_session.token if live_session.timestamp && live_session.timestamp >= t
      live_session.heartbeat_count = live_session.heartbeat_count.to_i + 1
      live_session.duration = live_session.duration.to_i + step
      live_session.heartbeat_at = Time.now
      live_session.timestamp = t
      live_session.beat_step = step
      live_session.save
      self.heartbeat_time = Time.now
      save
      live_session
    end

    def waiting_close?
      teaching? || paused?
    end

    # 剩余回放时间
    def left_replay_times
    end

    def waiting_billing?
      finished? || billing?
    end

    # 结账时长，都按1小时结账
    def duration_hours
      1
    end

    private

    def session_by_token(token)
      token ||= ::Encryption.md5("#{id}#{Time.now}").downcase
      live_sessions.find_or_create_by(token: token)
    end

    # 活动时间是否修改
    def event_time_changed?
      class_date_changed? || start_at_hour_changed? || start_at_min_changed?
    end

    # 计算活动时间
    before_validation :calculate_event_time, if: :event_time_changed?
    def calculate_event_time
      return if class_date.nil? || start_at_hour.nil? || start_at_min.nil?
      calculate_start_at!
      return if start_at.nil? || duration.nil?
      calculate_end_at!
    end

    # 计算开始时间
    def calculate_start_at!
      self.start_at = class_date.to_time
      self.start_at += start_at_hour.to_i.hours
      self.start_at += start_at_min.to_i.minutes
    end

    # 计算结束时间
    def calculate_end_at!
      self.end_at = start_at + duration_value.minutes
    end

    # 今日课程立即是ready状态
    def data_preview
      self.status = class_date == Date.today ? 1 : 0
    end

    def reset_status
      self.status = 'ready' if class_date == Date.today && status == 'missed'
      self.status = 'init' if class_date > Date.today && status == 'missed'
    end

    after_commit :update_group
    def update_group
      return unless group.present?
      lesson_dates = group.events(true).map(&:class_date)
      group.update(start_at: lesson_dates.min, end_at: lesson_dates.max)
    end

    # 增加计数器
    def increment_course_counter(attribute)
      group.increment(attribute)
    end
  end
end
