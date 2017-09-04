module LiveStudio
  # 学生家庭作业
  class StudentHomework < Task
    belongs_to :homework, foreign_key: 'parent_id'

    has_many :task_items, foreign_key: 'task_id'
  end
end
