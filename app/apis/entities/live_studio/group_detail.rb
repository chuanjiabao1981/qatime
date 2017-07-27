module Entities
  module LiveStudio
    class GroupDetail < Group
      expose :teacher, using: Entities::Teacher
      expose :offline_lessons, using: Entities::LiveStudio::OfflineLesson
      expose :scheduled_lessons, using: Entities::LiveStudio::ScheduledLesson
    end
  end
end
