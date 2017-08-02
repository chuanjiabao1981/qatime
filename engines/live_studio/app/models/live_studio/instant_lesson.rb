module LiveStudio
  class InstantLesson < Event
    include Recordable # 直播录制
    prepend PlayRecordWithJob

    belongs_to :group, counter_cache: false

    private

    def event_time_changed?
      false
    end

    def update_group
    end

    def can_billing?
      false
    end
  end
end
