class QaFile < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  mount_uploader :name, QaFileUploader
  belongs_to :qa_fileable,polymorphic: true
  belongs_to :author, class_name: "User"

  validates_presence_of :author

end