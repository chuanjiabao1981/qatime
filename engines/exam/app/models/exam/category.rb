module Exam
  # 题目分类
  class Category < ActiveRecord::Base
    belongs_to :paper

    has_many :topics, class_name: 'Exam::Topic'
    has_many :group_topics
    has_many :package_topics

    accepts_nested_attributes_for :topics
    accepts_nested_attributes_for :group_topics
    accepts_nested_attributes_for :package_topics

    def average_score
      result = (score.to_f / topics_count).round(1)
      result == result.to_i ? result.to_i : result
    rescue
      score
    end
  end
end
