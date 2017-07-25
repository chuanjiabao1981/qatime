require 'encryption'
module LiveStudio
  class Event < ActiveRecord::Base
    extend Enumerize
    include AASM

    has_soft_delete

    attr_accessor :start_time_hour, :start_time_minute, :_update

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

    before_create :data_preview
    after_commit :update_course

    before_validation :reset_status, if: :class_date_changed?, on: :update

    after_find do |lesson|
      lesson.start_time_hour, lesson.start_time_minute = lesson.start_time.split(":") if lesson.start_time.present?
    end

    before_validation :calculate_start_and_end_time
    def calculate_start_and_end_time
      self.start_time = "#{start_time_hour}:#{start_time_minute}" if start_time_hour.present? && start_time_minute.present?
      if start_time_changed? || duration_changed?
        end_hour = format("%02d", start_time_hour.to_i + (start_time_minute.to_i + duration_value) / 60)
        end_minute = format("%02d", (duration_value + start_time_minute.to_i) % 60)
        self.end_time = "#{end_hour}:#{end_minute}"
      end
    end

    def status_text(role = nil, outer = true)
      role == 'teacher' || role = 'student'
      I18n.t("lesson_status.#{role}.#{status}#{!outer && status == 'paused' ? '_inner' : ''}")
    end

    private

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
