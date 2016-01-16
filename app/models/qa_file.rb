class QaFile < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  mount_uploader :name, QaFileUploader
  belongs_to :qa_fileable,polymorphic: true
  belongs_to :author, class_name: "User"

  #attr_accessible :name, :original_filename, :author_id, :qa_file_type

  validates_presence_of :author
  has_many :qa_file_quoters
end