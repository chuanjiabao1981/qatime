module LiveStudio
  # 提问
  class Question < Task
    extend Enumerize
    enum status: { pending: 0, resolved: 2 }
    enumerize :status, in: { pending: 0, resolved: 2 }, default: :pending

    has_one :answer, foreign_key: 'parent_id'
    belongs_to :teacher

    private

    before_validation :set_teacher
    def set_teacher
      self.teacher ||= taskable.teacher
    end
  end
end
