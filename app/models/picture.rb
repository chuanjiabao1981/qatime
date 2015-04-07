class Picture < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  mount_uploader :name, PictureUploader

  belongs_to :imageable,polymorphic: true

  def self.update_imageable_info(imageable_item)
    Picture.where("token='#{imageable_item.token}'")
    .update_all({imageable_id:imageable_item.id})
  end
end
