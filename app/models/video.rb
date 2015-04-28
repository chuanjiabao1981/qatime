class Video < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  belongs_to :lesson

  #这些是不是要和teaching_video合并
  mount_uploader :name, VideoUploader
  mount_uploader :convert_name,VideoUploader
end