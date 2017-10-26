module LiveStudio
  class InstantLesson < Event
    include Recordable # 直播录制
    prepend PlayRecordWithJob

    belongs_to :group, counter_cache: false

    enum status: {
             ready: 1, # 待上课
             teaching: 2, # 上课中
             closed: 4, # 直播结束
         }

    aasm column: :status, enum: true do
      state :ready, initial: true
      state :teaching
      state :closed

      event :teach do
        before do
          self.live_start_at = Time.now
        end
        transitions from: [:ready, :closed], to: :teaching
      end

      event :close do
        before do
          self.live_end_at = Time.now
        end
        transitions from: [:teaching], to: :closed
      end
    end

    # 初始状态 直接开课
    default_value_for :status, statuses[:ready]
    default_value_for :class_date, Date.today

    private

    def event_time_changed?
      false
    end

    def update_group
    end

    def can_billing?
      false
    end

    def update_group_price
    end
  end
end
