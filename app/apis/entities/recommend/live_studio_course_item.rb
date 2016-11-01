module Entities
  module Recommend
    class LiveStudioCourseItem < Item
      expose :target, as: :live_studio_course, using: ::Entities::LiveStudio::Course
    end
  end
end
