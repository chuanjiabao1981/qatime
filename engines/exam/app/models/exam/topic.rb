module Exam
  class Topic < ActiveRecord::Base
    belongs_to :paper
    belongs_to :category
    belongs_to :group_topic
    belongs_to :package_topic
    has_many :options
    accepts_nested_attributes_for :options

    # mount_uploader :attach, Exam::AttachUploader
  end
end
