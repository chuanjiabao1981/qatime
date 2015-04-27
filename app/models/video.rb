class Video < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  mount_uploader :name, VideoUploader
  belongs_to :lesson

end