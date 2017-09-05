module LiveStudio
  # 家庭作业批改
  class Correction < Task
    belongs_to :student_homework, foreign_key: 'parent_id'
    has_many :task_items, foreign_key: 'task_id'

    validates :student_homework, presence: true
  end
end
