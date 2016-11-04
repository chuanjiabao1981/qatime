module Entities
  module Recommend
    class LiveStudioCourseItem < Item
      expose :target, as: :live_studio_course, using: ::Entities::LiveStudio::Course

      expose :logo_url do |item|
        item.target.publicize_url(:info)
      end
    end
  end
end
