module Exam
  # 题目分类
  class Category < ActiveRecord::Base
    belongs_to :paper

    has_many :topics
    has_many :group_topics
    has_many :package_topics

    accepts_nested_attributes_for :topics
    accepts_nested_attributes_for :group_topics
    accepts_nested_attributes_for :package_topics
  end
end
