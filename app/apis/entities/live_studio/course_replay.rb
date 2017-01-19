module Entities
  module LiveStudio
    class CourseReplay < Grape::Entity
      expose :id
      expose :lessons, using: Entities::LiveStudio::VideoLesson
    end
  end
end
