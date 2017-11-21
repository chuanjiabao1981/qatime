module LiveStudio
  # 家庭作业批改
  class Correction < Task
    belongs_to :student_homework, foreign_key: 'parent_id'
    has_many :task_items, foreign_key: 'task_id'

    validates :student_homework, presence: true

    accepts_nested_attributes_for :task_items

    after_create :resolve_student_homework
    def resolve_student_homework
      if student_homework.submitted?
        student_homework.resolve!
        feeds('resolve')
      else
        feeds('update_resolve')
      end
    end

    private

    def feeds(event)
      Social::Feed.transaction do
        # 生成动态
        feed = Social::CourseHomeworkFeed.create!(feedable: self, event: event, producer: user, linkable: taskable, workstation: taskable.workstation, target: parent.user)
        # 老师发布动态
        feed.feed_publishs.create!(publisher: user)
        # 课程发布动态
        feed.feed_publishs.create!(publisher: taskable)
      end
    end
  end
end
