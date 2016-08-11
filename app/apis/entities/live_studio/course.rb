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
      expose :live_start_time
      expose :live_end_time
      expose :publicize do |course|
        options[:type] == :full ? course.publicize_url(:info) : course.publicize_url(:list)
      end
      expose :lessons, using: Entities::LiveStudio::Lesson, if: { type: :full }
      expose :chat_team, using: Entities::Chat::Team, if: { type: :full } do |course|
        course.chat_team
      end
    end
  end
end
