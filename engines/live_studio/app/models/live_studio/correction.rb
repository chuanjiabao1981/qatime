module LiveStudio
  # 家庭作业批改
  class Correction < Task
    belongs_to :student_homework, foreign_key: 'parent_id'
    has_many :task_items, foreign_key: 'task_id'

    validates :student_homework, presence: true

    accepts_nested_attributes_for :task_items

    after_commit :asyn_send_task_message, on: :create

    after_create :resolve_student_homework
    def resolve_student_homework
      student_homework.resolved! if student_homework.submitted?
    end
  end
end
