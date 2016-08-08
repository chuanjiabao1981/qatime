module Entities
  module LiveStudio
    class StudentCourse < Course
      expose :pull_address do |course|
        course.pull_stream.try(:address)
      end
      expose :teacher, using: Entities::LiveStudio::Teacher, if: { type: :full }
    end
  end
end
