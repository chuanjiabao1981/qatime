module Entities
  module LiveStudio
    class Lesson < Grape::Entity
      expose :id
      expose :name
      expose :status
      expose :class_date
      expose :live_time
      expose :live_token, if: { type: :live_start } do |lesson|
        lesson.current_live_session.token
      end
    end
  end
end
