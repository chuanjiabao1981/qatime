class Cover < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  belongs_to :course
  mount_uploader :name, CoverUploader
end
