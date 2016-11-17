module Recommend
  class BannerItem < Item
    mount_uploader :logo, ::BannerLogoUploader
  end
end
