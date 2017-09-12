module LiveStudio
  # 专属课任务
  class Task < ActiveRecord::Base
    default_scope { order("id desc") }

    belongs_to :taskable, polymorphic: true
    belongs_to :user

    belongs_to :parent, class_name: 'LiveStudio::Task'

    delegate :id, :name, to: :user, prefix: true

    validates :taskable, :user, presence: true

    before_validation :copy_parent
    def copy_parent
      return unless parent
      self.title ||= parent.title
      self.body ||= parent.body
      self.taskable ||= parent.taskable
    end
  end
end
