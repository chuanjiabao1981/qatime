module Entities
  module LiveStudio
    class CourseLesson < Grape::Entity
      expose :id
      expose :name
      expose :status
      expose :course_id
      expose :real_time
      expose :pos
      expose :class_date
      expose :live_time
      expose :replayable
      expose :left_replay_times
    end
  end
end
