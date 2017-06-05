module Entities
  module Recommend
    class ChoicenessItem < Item
      expose :target_type do |item|
        item.target_type_value
      end
      expose :target_id
      expose :target, as: :live_studio_course, if: lambda { |object, options| object.target.is_a?(::LiveStudio::Course) }, using: ::Entities::LiveStudio::Course
      expose :target, as: :live_studio_interactive_course, if: lambda { |object, options| object.target.is_a?(::LiveStudio::InteractiveCourse) }, using: ::Entities::LiveStudio::InteractiveCourse
      expose :target, as: :live_studio_video_course, if: lambda { |object, options| object.target.is_a?(::LiveStudio::VideoCourse) }, using: ::Entities::LiveStudio::VideoCourse
      expose :reason
      expose :logo_url do |item|
        item.target.try(:publicize_url, :info)
      end
      expose :tag_one
      expose :tag_two do |item|
        nil
      end
    end
  end
end
