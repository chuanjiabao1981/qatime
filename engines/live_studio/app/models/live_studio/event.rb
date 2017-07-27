require 'encryption'
module LiveStudio
  class Event < ActiveRecord::Base
    has_soft_delete
    include AASM
    extend Enumerize

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

    validates :name, :class_date, presence: true

    # 开始时间
    def start_time
      start_at.try(:strftime, '%H:%M')
    end

    # 结束时间
    def end_time
      end_at.try(:strftime, '%H:%M')
    end

    def status_text(role = nil, outer = true)
      role == 'teacher' || role = 'student'
      I18n.t("lesson_status.#{role}.#{status}#{!outer && status == 'paused' ? '_inner' : ''}")
    end

    private

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

    def update_course
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