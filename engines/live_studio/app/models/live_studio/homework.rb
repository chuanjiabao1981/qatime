module LiveStudio
  # 家庭作业
  class Homework < Task
    has_many :task_items, foreign_key: 'task_id'
    has_many :student_homeworks, foreign_key: 'parent_id'

    accepts_nested_attributes_for :task_items
  end
end
