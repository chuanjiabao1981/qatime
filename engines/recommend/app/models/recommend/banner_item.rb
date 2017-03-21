module Recommend
  class BannerItem < Item
    mount_uploader :logo, ::BannerLogoUploader
    validates_presence_of :logo, :title
    validates :index, presence: true, numericality: { only_integer: true }
    validates_uniqueness_of :index, scope: [:position_id, :city_id, :deleted_at], message: I18n.t('view.recommend/position.banner_item_uniq_valid')
  end
end
