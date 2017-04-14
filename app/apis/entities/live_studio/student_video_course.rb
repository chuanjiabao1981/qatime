module Entities
  module LiveStudio
    class StudentVideoCourse < Entities::LiveStudio::VideoCourse

      expose :is_bought do |course, options|
        course.bought_by?(options[:current_user])
      end
    end
  end
end
