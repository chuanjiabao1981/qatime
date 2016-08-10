module Entities
  module LiveStudio
    class StudentCourse < Entities::LiveStudio::Course

      expose :pull_address do |course|
        course.pull_stream.try(:address)
      end
      expose :teacher, using: Entities::Teacher, if: { type: :full }
      expose :is_tasting do |course, options|
        course.tasting?(options[:current_user])
      end
      expose :is_bought do |course, options|
        course.bought_by?(options[:current_user])
      end
    end
  end
end
