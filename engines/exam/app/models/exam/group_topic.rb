module Exam
  # 题目组, 用于包装题目
  class GroupTopic < Topic
    has_many :topics
  end
end
