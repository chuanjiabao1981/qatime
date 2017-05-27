module Entities
  module LiveStudio
    class VideoLessonPlay < Grape::Entity
      expose :id
      expose :name
      expose :duration
      expose :video, using: Entities::Video
    end
  end
end
