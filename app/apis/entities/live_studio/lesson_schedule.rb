module Entities
  module LiveStudio
    class LessonSchedule < Grape::Entity
      format_with(:local_timestamp, &:to_i)

      expose :id
      expose :model_name
      expose :name
      expose :course_id
      expose :course_model_name
      expose :status
      expose :publicizes do |lesson|
        lesson.publicize.versions
      end
      with_options(format_with: :local_timestamp) do
        expose :start_at
      end
    end
  end
end
