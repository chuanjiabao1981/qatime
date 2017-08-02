module LiveStudio
  class OfflineLesson < Event
    validates :name, :class_date, :start_at, :end_at, presence: true

    enum status: {
             init: 0, # 未开始
             ready: 1, # 待上课
             teaching: 2, # 上课中
             finished: 5, # 已上课
             billing: 6, # 结账中
             completed: 7 # 已结束
         }

    aasm column: :status, enum: true do
      state :init, initial: true
      state :ready
      state :teaching
      state :finished
      state :billing
      state :completed

      event :ready do
        transitions from: [:init], to: :ready
      end

      event :teach do
        before do
          increment_course_counter(:started_events_count) if unstart?
        end
        transitions from: [:ready], to: :teaching
      end

      event :complete do
        before do
          increment_course_counter(:closed_events_count) if live_end_at.nil?
          self.live_end_at = Time.now
        end
        transitions from: [:finished, :billing], to: :completed
      end
    end

    def status_text(role = nil, outer = true)
      I18n.t("offline_lesson_status.#{status}")
    end

    # 是否可以直播
    def can_live?
      false
    end

    # 是否可以回放
    def replayable
      false
    end
  end
end
