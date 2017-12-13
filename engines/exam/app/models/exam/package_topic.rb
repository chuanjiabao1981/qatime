module Exam
  # 题目包用于包装题目组和题目
  class PackageTopic < Exam::Topic
    has_many :group_topics
    has_many :topics, class_name: 'Exam::Topic'

    accepts_nested_attributes_for :group_topics
    accepts_nested_attributes_for :topics

    # 编辑完成进度
    def finished_topics_count
      pending? ? 0 : total_topics_count
    end

    # 总题目数
    def total_topics_count
      topics.sum(&:total_topics_count)
    end
  end
end
