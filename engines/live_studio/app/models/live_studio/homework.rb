module LiveStudio
  # 家庭作业
  class Homework < Task
    has_many :task_items, foreign_key: 'task_id'
    has_many :student_homeworks, foreign_key: 'parent_id'

    include Social::Feedable
    publish_feeds :after_create, :homework_create_feeds

    accepts_nested_attributes_for :task_items

    # 作业创建以后派发给学生
    after_create :dispatch_homeworks

    validates :title, presence: true, length: { in: 2..20 }

    # 作业派发
    def dispatch_homeworks
      taskable.buy_tickets.includes(:student).available.each do |ticket|
        student_homeworks.create(teacher: user, user: ticket.student, taskable: taskable, title: title, body: body)
      end
    end

    after_commit :asyn_send_team_message, on: :create

    # 给学生补发作业
    def dispatch_to(student)
      student_homeworks.create(teacher: user, user: student, taskable: taskable, title: title, body: body, status: 'expired')
    end

    # 布置作业动态
    def homework_create_feeds
      Social::Feed.transaction do
        # 生成动态
        feed = Social::CourseHomeworkFeed.create!(feedable: self, event: 'create', producer: user, linkable: taskable, workstation: taskable.workstation)
        # 老师发布动态
        feed.feed_publishs.create!(publisher: user)
        # 课程发布动态
        feed.feed_publishs.create!(publisher: taskable)
      end
    end
  end
end
