module Exam
  class Paper < ActiveRecord::Base
    enum status: { unpublished: 0, published: 1 }
    belongs_to :workstation, class_name: '::Workstation'

    has_many :topics
    has_many :categories
    accepts_nested_attributes_for :categories

    validates :name, presence: true
    validates :grade_category, presence: true
    validates :subject, presence: true
    validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }
  end
end
