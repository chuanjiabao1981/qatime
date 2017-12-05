module Exam
  # 题目分类
  class Category < ActiveRecord::Base
    belongs_to :paper

    has_many :topics
    has_many :group_topics
    has_many :package_topics
  end
end
