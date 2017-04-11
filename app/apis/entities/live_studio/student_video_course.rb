module Entities
  module LiveStudio
    class StudentVideoCourse < Entities::LiveStudio::VideoCourse

      with_options(format_with: :local_timestamp) do
        expose :start_at, as: :preview_time
      end

      expose :is_bought do |course, options|
        course.bought_by?(options[:current_user])
      end
    end
  end
end
