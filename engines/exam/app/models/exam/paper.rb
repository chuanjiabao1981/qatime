module Exam
  class Paper < ActiveRecord::Base
    belongs_to :workstation, class_name: '::Workstation'

    has_many :topics
    has_many :categories
    accepts_nested_attributes_for :categories
  end
end
