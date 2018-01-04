module Exam
  # 题目组, 用于包装题目
  class GroupTopic < Exam::Topic
    has_many :topics, -> { order(:pos) }, class_name: 'Exam::Topic', dependent: :destroy, validate: true

    accepts_nested_attributes_for :topics

    validates :attach, presence: true, on: :update, unless: :had_package?
    validates :title, presence: true, on: :update, if: :had_package?

    # 编辑完成进度
    def finished_topics_count
      pending? ? 0 : topics_count
    end

    # 总题目数
    def total_topics_count
      topics_count
    end

    private

    def had_package?
      package_topic_id.present?
    end
  end
end
