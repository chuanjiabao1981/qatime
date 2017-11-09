module LiveStudio
  # 学生家庭作业
  class StudentHomework < Task
    extend Enumerize
    include AASM

    enum status: { pending: 0, submitted: 1, resolved: 2, expired: 99 }
    enumerize :status, in: { pending: 0, submitted: 1, resolved: 2 }, default: :pending

    aasm column: :status, enum: true do
      state :pending, initial: true
      state :submitted
      state :resolved
      state :expired

      event :publish, after_commit: :publish_hook do
        before do
          self.published_at = Time.now
        end
        transitions from: :pending, to: :submitted
      end

      event :resolve do
        before do
          self.resolved_at = Time.now
        end
        transitions from: :submitted, to: :resolved
      end
    end

    scope :published, -> { where(status: statuses.values_at(:submitted, :resolved)) }

    belongs_to :homework, foreign_key: 'parent_id'
    belongs_to :teacher
    has_one :correction, foreign_key: 'parent_id'
    has_many :corrections, foreign_key: 'parent_id'
    has_many :task_items, foreign_key: 'task_id'

    validates :homework, presence: true

    accepts_nested_attributes_for :task_items

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

    # 提交作业回调
    def publish_hook
      LiveStudio::Homework.increment_counter(:tasks_count, parent_id) if pending? && submitted!
    end
  end
end
