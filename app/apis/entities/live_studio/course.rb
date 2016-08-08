module Entities
  module LiveStudio
    class Course < Grape::Entity
      expose :id
      expose :name
      expose :subject
      expose :status
      expose :description
      expose :lesson_count
      expose :preset_lesson_count
      expose :completed_lesson_count
      expose :lessons, using: Entities::LiveStudio::Lesson, if: { type: :full }
    end
  end
end
