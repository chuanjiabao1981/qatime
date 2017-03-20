module Entities
  module Recommend
    class ChoicenessItem < Item
      expose :target, as: :live_studio_course, using: ::Entities::LiveStudio::Course
      expose :reason
      expose :logo_url do |item|
        item.target.try(:publicize_url, :info)
      end
      expose :tag_one
      expose :tag_two
    end
  end
end
