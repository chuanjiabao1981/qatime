module Entities
  module LiveStudio
    class TeacherCourse < Entities::LiveStudio::Course
      expose :push_address do |course|
        course.push_stream.try(:address)
      end

      expose :board do |course|
        course.push_streams.find {|stream| stream.use_for == :borad }.try(:address)
      end

      expose :camera do |course|
        course.push_streams.find {|stream| stream.use_for == :camera }.try(:address)
      end
    end
  end
end
