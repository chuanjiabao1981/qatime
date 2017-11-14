module Entities
  module LiveStudio
    class VideoCourseLesson < Grape::Entity
      expose :id
      expose :name
      expose :status
      expose :video_course_id
      expose :real_time
      expose :pos
      expose :tastable
      expose :quote, as: :video, using: Entities::Resource::VideoQuote
    end
  end
end
