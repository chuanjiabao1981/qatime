module Entities
  module LiveStudio
    class TodayLesson < Lesson
      expose :course, using: Entities::LiveStudio::Course
    end
  end
end
