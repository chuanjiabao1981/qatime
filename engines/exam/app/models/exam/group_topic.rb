module Exam
  # 题目组, 用于包装题目
  class GroupTopic < Exam::Topic
    has_many :topics, class_name: 'Exam::Topic'

    accepts_nested_attributes_for :topics

    # 编辑完成进度
    def finished_topics_count
      pending? ? 0 : topics_count
    end

    # 总题目数
    def total_topics_count
      topics_count
    end
  end
end
