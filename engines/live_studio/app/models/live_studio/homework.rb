module LiveStudio
  # 家庭作业
  class Homework < Task
    has_many :task_items, foreign_key: 'task_id'
    has_many :student_homeworks, foreign_key: 'parent_id'

    accepts_nested_attributes_for :task_items

    # 作业创建以后派发给学生
    after_create :dispatch_homeworks

    # 作业派发
    def dispatch_homeworks
      taskable.buy_tickets.includes(:student).available.each do |ticket|
        student_homeworks.create(teacher: user, user: ticket.student, taskable: taskable, title: title, body: body)
      end
    end
  end
end
