module LiveStudio
  # 学生家庭作业
  class StudentHomework < Task
    extend Enumerize

    enum status: { pending: 0, submitted: 1, resolved: 2 }
    enumerize :status, in: { pending: 0, submitted: 1, resolved: 2 }, default: :pending

    scope :published, -> { where(status: statuses.values_at(:submitted, :resolved)) }

    belongs_to :homework, foreign_key: 'parent_id'
    belongs_to :teacher
    has_one :correction, foreign_key: 'parent_id'
    has_many :task_items, foreign_key: 'task_id'

    validates :homework, presence: true

    accepts_nested_attributes_for :task_items

    # 提交作业
    def publish!
      LiveStudio::Homework.increment_counter(:tasks_count, parent_id) if pending? && submitted!
    end

    def status_text(role = 'student')
      return status.text if role == 'student'
      I18n.t("enumerize.live_studio/student_homework.teacher.status.#{status}")
    end

    def self.teacher_status_text(status)
      I18n.t("enumerize.live_studio/student_homework.teacher.status.#{status}")
    end

    private :submitted!

    # 提交作业
    after_save :submit_homework
    def submit_homework
      publish! if pending? && task_items.present?
    end
  end
end
