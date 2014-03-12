class Cover < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  mount_uploader :name, CoverUploader
end
