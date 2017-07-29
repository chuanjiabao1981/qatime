module LiveStudio
  class InstantLesson < Event
    include Recordable # 直播录制
    prepend PlayRecordWithJob

    belongs_to :group, counter_cache: :false
  end
end
