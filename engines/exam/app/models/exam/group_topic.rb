module Exam
  # 题目组, 用于包装题目
  class GroupTopic < Exam::Topic
    has_many :topics

    accepts_nested_attributes_for :topics
  end
end
