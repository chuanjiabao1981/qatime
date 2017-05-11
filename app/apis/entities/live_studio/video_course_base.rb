module Entities
  module LiveStudio
    class VideoCourseBase < Grape::Entity
      format_with(:local_timestamp, &:to_i)
      expose :id
      expose :name
      expose :subject
      expose :grade
      expose :teacher_name
      expose :publicize do |video_course|
        video_course.publicize_url(:app_info)
      end
    end
  end
end
