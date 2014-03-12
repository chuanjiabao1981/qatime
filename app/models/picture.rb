class Picture < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  mount_uploader :name, PictureUploader
end
