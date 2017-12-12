module Exam
  class Paper < ActiveRecord::Base
    enum status: { unpublished: 0, published: 1 }

    scope :for_sell, -> { where(status: 1) }

    belongs_to :workstation, class_name: '::Workstation'

    has_many :topics
    has_many :categories
    accepts_nested_attributes_for :categories

    validates :name, presence: true
    validates :grade_category, presence: true
    validates :subject, presence: true
    validates :price, presence: true, numericality: { greater_than: 0 }

    def users_count
      0
    end

    def grade_category_subject
      "#{grade_category}#{subject}"
    end
  end
end
