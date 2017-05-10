module Entities
  module LiveStudio
    class VideoLessonPlay < VideoLesson
      expose :video, using: Entities::Video
      expose :video_course
    end
  end
end
