module LiveStudio
  class OfflineLesson < Event
    enum status: {
             init: 0, # 未开始
             ready: 1, # 待上课
             teaching: 2, # 上课中
             completed: 7 # 已结束
         }

    aasm column: :status, enum: true do
      state :init, initial: true
      state :ready
      state :teaching
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
        after do
          # 结算后增加辅导班结算数量
          increment_course_counter(:closed_events_count)
        end
        transitions from: [:teaching], to: :completed
      end
    end

    def status_text(role = nil, outer = true)
      I18n.t("offline_lesson_status.#{status}")
    end
  end
end
