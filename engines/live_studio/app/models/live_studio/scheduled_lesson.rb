module LiveStudio
  class ScheduledLesson < Event

    aasm column: :status, enum: true do
      state :init, initial: true
      state :missed
      state :ready
      state :teaching
      state :paused
      state :closed
      state :finished
      state :billing
      state :completed

      event :miss do
        transitions from: [:ready, :init], to: :missed
      end

      event :ready do
        transitions from: [:init, :missed], to: :ready
      end

      event :teach do
        before do
          # 第一次开始直播增加开始数量
          increment_course_counter(:started_lessons_count) if unstart?
        end
        transitions from: [:ready, :paused, :missed, :closed], to: :teaching
      end

      event :pause do
        transitions from: :teaching, to: :paused
      end

      event :close, after_commit: :close_hook  do
        before do
          # 第一次结束直播增加结束数量
          increment_course_counter(:closed_lessons_count) if live_end_at.nil?
          self.live_end_at = Time.now
        end
        transitions from: [:teaching, :paused], to: :closed
      end

      event :finish, after_commit: :finish_hook do
        after do
          # 课程完成增加辅导班完成课程数量 & 异步更新录制视频列表
          increment_course_counter(:finished_lessons_count)
        end
        transitions from: [:closed], to: :finished
      end

      event :complete do
        after do
          # 结算后增加辅导班结算数量
          increment_course_counter(:completed_lessons_count)
        end
        transitions from: [:finished, :billing], to: :completed
      end
    end
  end
end
