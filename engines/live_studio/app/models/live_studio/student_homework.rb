module LiveStudio
  # 学生家庭作业
  class StudentHomework < Task
    extend Enumerize
    enumerize :status, in: { pending: 1, resolved: 2 }, default: :pending

    belongs_to :homework, foreign_key: 'parent_id', counter_cache: :tasks_count
    has_one :correction, foreign_key: 'parent_id'
    has_many :task_items, foreign_key: 'task_id'

    validates :homework, presence: true

    accepts_nested_attributes_for :task_items
  end
end
