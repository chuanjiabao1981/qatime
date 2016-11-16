module Entities
  module LiveStudio
    class TeacherCourse < Entities::LiveStudio::Course
      expose :push_address do |course|
        course.board_push_stream
      end

      expose :board_push_stream
      expose :camera_push_stream

      expose :board do |course|
        course.board_push_stream
      end

      expose :camera do |course|
        course.camera_push_stream
      end
    end
  end
end
