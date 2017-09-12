module LiveStudio
  # 提问
  class Question < Task
    has_many :task_items, -> { where(parent_id: nil).includes(:task_items) }, foreign_key: 'task_id'
  end
end
