class Picture < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  mount_uploader :name, PictureUploader

  belongs_to :imageable,polymorphic: true
end
