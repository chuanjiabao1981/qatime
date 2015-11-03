class Picture < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  mount_uploader :name, PictureUploader

  belongs_to :imageable,polymorphic: true
  belongs_to :author,class_name:  User

  def self.update_imageable_info(imageable_item,imageable_type)
    Picture.where("token='#{imageable_item.token}'")
    .update_all({imageable_id:imageable_item.id,imageable_type: imageable_type})
  end
end
