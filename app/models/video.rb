
class Video < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  belongs_to :videoable,polymorphic: true
  include VideoConvert

end


class VideoChangedWhenConvertingException < Exception
end