module Exam
  # 题目包用于包装题目组和题目
  class PackageTopic < Topic
    has_many :group_topics
    has_many :topics
  end
end
