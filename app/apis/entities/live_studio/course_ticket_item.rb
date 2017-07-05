module Entities
  module LiveStudio
    class CourseTicketItem < Grape::Entity
      expose :target, as: :lesson, using: Entities::LiveStudio::LessonBase
      expose :status
      expose :tp
    end
  end
end
