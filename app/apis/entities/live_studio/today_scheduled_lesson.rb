module Entities
  module LiveStudio
    class TodayScheduledLesson < ScheduledLesson
      expose :group, as: :customized_group, using: Entities::LiveStudio::Group
    end
  end
end
