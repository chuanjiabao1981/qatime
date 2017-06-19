module Entities
  module Recommend
    class ReplayItem < Item
      format_with(:local_timestamp, &:to_i)
      expose :logo_url do |item|
        item.logo_url
      end
      expose :top
      expose :replay_times
      with_options(format_with: :local_timestamp) do
        expose :updated_at
      end
      expose :target_type
      expose :target_id
      expose :target, as: :live_studio_lesson, if: lambda { |object, options| object.target.is_a?(::LiveStudio::Lesson) }, using: ::Entities::LiveStudio::Lesson
    end
  end
end
