module LiveStudio
  # 家庭作业
  class Homework < Task
    has_many :task_items, foreign_key: 'task_id'
  end
end
