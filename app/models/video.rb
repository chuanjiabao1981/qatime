
class Video < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  belongs_to :lesson
  include VideoConvert

end


class VideoChangedWhenConvertingException < Exception
end