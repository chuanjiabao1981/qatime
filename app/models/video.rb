
class Video < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  belongs_to :videoable,polymorphic: true
  belongs_to :author, class_name: "User"
  include VideoConvert

  validates_presence_of :author
end


class VideoChangedWhenConvertingException < Exception
end