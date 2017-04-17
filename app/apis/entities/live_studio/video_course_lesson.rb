module Entities
  module LiveStudio
    class VideoCourseLesson < Grape::Entity
      expose :id
      expose :name
      expose :status
      expose :video_course_id
      expose :real_time
      expose :pos
      expose :video, using: Entities::Video
    end
  end
end
