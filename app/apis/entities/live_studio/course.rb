module Entities
  module LiveStudio
    class Course < Grape::Entity
      expose :id
      expose :name
      expose :subject do |course|
        course.subject.to_s
      end
      expose :grade do |course|
        course.grade.to_s
      end
      expose :status
      expose :description
      expose :lesson_count
      expose :preset_lesson_count
      expose :completed_lesson_count
      expose :push_address do |course|
        course.push_stream.try(:address)
      end
      expose :lessons, using: Entities::LiveStudio::Lesson, if: { type: :full }
      expose :teacher, using: Entities::LiveStudio::Teacher, if: { type: :full }
    end
  end
end
