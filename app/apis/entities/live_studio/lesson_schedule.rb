module Entities
  module LiveStudio
    class LessonSchedule < Grape::Entity
      expose :id
      expose :model_name
      expose :name
      expose :start_at
      expose :course_id
      expose :course_model_name
    end
  end
end
