module Exam
  # 题目包用于包装题目组和题目
  class PackageTopic < Exam::Topic
    has_many :group_topics
    has_many :topics
    
    accepts_nested_attributes_for :group_topics
    accepts_nested_attributes_for :topics
  end
end
