module Entities
  module LiveStudio
    class CourseTicketItem < Grape::Entity
      expose :target, as: :video_lesson, using: Entities::LiveStudio::LessonBase
      expose :status
    end
  end
end
