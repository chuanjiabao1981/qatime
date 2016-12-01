module Entities
  module Recommend
    class BannerItem < Item
      expose :logo_url do |item|
        item.logo_url
      end
      expose :link
    end
  end
end
