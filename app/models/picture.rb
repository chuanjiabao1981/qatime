class Picture < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  mount_uploader :name, PictureUploader

  belongs_to :imageable,polymorphic: true
  belongs_to :author,class_name:  User
  has_many :picture_quoters
end
