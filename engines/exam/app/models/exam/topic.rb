module Exam
  class Topic < ActiveRecord::Base
    enum status: { pending: 0, finished: 9 }
    belongs_to :paper
    belongs_to :category
    belongs_to :group_topic, counter_cache: true
    belongs_to :package_topic, counter_cache: true
    has_many :topic_options, class_name: 'Exam::Option', validate: true
    has_many :topics, foreign_key: "group_topic_id", class_name: 'Exam::Topic'

    accepts_nested_attributes_for :topic_options
    accepts_nested_attributes_for :topics

    mount_uploader :attach, Exam::AttachUploader
    mount_uploader :answer_attach, Exam::AttachUploader

    # 编辑完成进度
    def finished_topics_count
      pending? ? 0 : 1
    end

    # 总题目数
    def total_topics_count
      1
    end

    before_save :set_paper
    def set_paper
      self.paper ||= category.paper if category
      self.paper ||= package_topic.paper if package_topic
      self.paper ||= group_topic.paper if group_topic
    end

    def can_finish?
      pending?
    end

    private

    after_update :update_status
    def update_status
      finished! if can_finish?
    end
  end
end
