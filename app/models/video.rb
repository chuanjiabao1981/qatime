
class Video < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  belongs_to :videoable,polymorphic: true
  belongs_to :author, class_name: "User"
  include VideoConvert

  validates_presence_of :author

  # def self.update_videoable_info(videoable_item)
  #   Video.where("token='#{videoable_item.token}'")
  #       .update_all({videoable_id: videoable_item.id,videoable_type: videoable_item.class.to_s})
  # end
end


class VideoChangedWhenConvertingException < Exception
end