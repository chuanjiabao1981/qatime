module Recommend
  class BannerItem < Item
    mount_uploader :logo, ::BannerLogoUploader
    validates_presence_of :logo, :link
  end
end
