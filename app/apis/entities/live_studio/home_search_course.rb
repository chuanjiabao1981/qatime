module Entities
  module LiveStudio
    class HomeSearchCourse < Grape::Entity
      expose :product_type do |course|
        course.model_name
      end
      expose :product, if: lambda { |object, options| object.is_a?(::LiveStudio::Course) } do |instance, options|
        ::Entities::LiveStudio::Course.represent instance
      end
      expose :product, if: lambda { |object, options| object.is_a?(::LiveStudio::InteractiveCourse) } do |instance, options|
        ::Entities::LiveStudio::InteractiveCourse.represent instance
      end
      expose :product, if: lambda { |object, options| object.is_a?(::LiveStudio::VideoCourse) } do |instance, options|
        ::Entities::LiveStudio::VideoCourse.represent instance
      end
      # expose :product, if: lambda { |object, options| object.is_a?(::LiveStudio::CustomizedGroup) } do |instance, options|
      #   ::Entities::LiveStudio::Group.represent instance
      # end
      expose :total_entries do |course|
        options[:total_entries]
      end
    end
  end
end
