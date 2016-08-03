module Entities
  module LiveStudio
    class TeacherCourse < Course
      expose :push_address do |course|
        course.push_stream.try(:address)
      end
    end
  end
end
