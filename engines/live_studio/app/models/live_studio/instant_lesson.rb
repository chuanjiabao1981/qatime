module LiveStudio
  class InstantLesson < Event
    belongs_to :group, counter_cache: :false
  end
end
