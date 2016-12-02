module Entities
  module Recommend
    class LiveStudioCourseItem < Item
      expose :target, as: :live_studio_course, using: ::Entities::LiveStudio::Course
      expose :reason
      expose :logo_url do |item|
        item.target.try(:publicize_url, :info)
      end
    end
  end
end
