module Entities
  module LiveStudio
    class TeacherSearchSchedule < Grape::Entity
      expose :date
      expose :lessons, using: Entities::LiveStudio::ScheduleLesson
    end
  end
end
