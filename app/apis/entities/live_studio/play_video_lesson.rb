module Entities
  module LiveStudio
    class PlayVideoLesson < VideoLesson
      expose :video, using: Entities::Video
      expose :video_course
    end
  end
end
