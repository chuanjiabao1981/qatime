module LiveStudio
  # 回答
  class Answer < Task
    belongs_to :question, foreign_key: 'parent_id'

    after_create :resolve_question
    def resolve_question
      question.resolved! if question.pending?
    end
  end
end
