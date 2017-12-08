module Exam
  class Topic < ActiveRecord::Base
    enum status: { pending: 0, finished: 9 }
    belongs_to :paper
    belongs_to :category
    belongs_to :group_topic, counter_cache: true
    belongs_to :package_topic, counter_cache: true
    has_many :options
    accepts_nested_attributes_for :options

    # 编辑完成进度
    def finished_topics_count
      pending? ? 0 : 1
    end

    # 总题目数
    def total_topics_count
      1
    end

    # mount_uploader :attach, Exam::AttachUploader
  end
end
