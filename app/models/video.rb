
class Video < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  belongs_to :videoable,polymorphic: true
  belongs_to :author, class_name: "User"
  include VideoConvert

  validates_presence_of :author

  def self.update_videoable_info(videoable_item,videoable_type)
    Video.where("token='#{videoable_item.token}'")
        .update_all({videoable_id: videoable_item.id,videoable_type: videoable_type})
  end

  has_many :video_quoters
  accepts_nested_attributes_for :video_quoters

end


class VideoChangedWhenConvertingException < Exception
end