module Entities
  module LiveStudio
    class Lesson < Grape::Entity
      expose :id
      expose :name
      expose :status
      expose :class_date
      expose :live_time
      expose :course_name do |lesson|
        lesson.course.name
      end
      expose :live_token, if: { type: :live_start } do |lesson|
        lesson.current_live_session.token
      end
    end
  end
end
