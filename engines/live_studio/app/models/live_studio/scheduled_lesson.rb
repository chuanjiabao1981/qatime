module LiveStudio
  class ScheduledLesson < Event
    include Recordable # 直播录制
    prepend PlayRecordWithJob

    validates :name, :class_date, :start_at, :end_at, presence: true

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
          increment_course_counter(:started_events_count) if unstart?
        end
        transitions from: [:ready, :paused, :missed, :closed], to: :teaching
      end

      event :pause do
        transitions from: :teaching, to: :paused
      end

      event :close, after_commit: :close_hook do
        before do
          # 第一次结束直播增加结束数量
          increment_course_counter(:closed_events_count) if live_end_at.nil?
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
        transitions from: [:finished, :billing], to: :completed
      end
    end

    # 是否可以回放
    def replayable
      had_closed? && merged?
    end

    # 是否可观看回放
    def replayable_for?(user)
      return false if user.blank?
      return true if user.admin?
      return false unless group.buy_tickets.where(student_id: user.id).available.exists?
      return false unless group.play_authorize(user, nil)
      true
    end

    # 课程完成回调
    def finish_hook
      # 记录播放记录
      # instance_play_records
      # 获取回放视频
      async_fetch_replays
    end

    # 结束直播回调
    def close_hook
      async_fetch_replays
    end

  end
end
