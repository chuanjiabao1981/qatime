module LiveStudio
  # 任务拥有者
  module Taskable
    extend ActiveSupport::Concern

    included do
      has_many :homeworks, as: :taskable # 家庭作业
      has_many :student_homeworks, as: :taskable # 学生提交的家庭作业
      has_many :questions, as: :taskable # 提问
    end
  end
end
