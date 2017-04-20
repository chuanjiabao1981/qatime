module Entities
  module LiveStudio
    class StudentVideoCourse < Entities::LiveStudio::VideoCourse

      expose :is_tasting do |course, options|
        course.tasting?(options[:current_user])
      end
      expose :is_bought do |course, options|
        course.bought_by?(options[:current_user])
      end

      expose :tasted do |course, options|
        course.tasted?(options[:current_user])
      end
    end
  end
end
