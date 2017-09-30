module LiveStudio
  # 回答
  class Answer < Task
    belongs_to :question, foreign_key: 'parent_id'
    has_many :quotes, as: :quoter
    has_many :attachments, through: :quotes, class_name: 'LiveStudio::Attachment'
    accepts_nested_attributes_for :quotes

    after_commit :asyn_send_team_message, on: :create

    after_create :resolve_question
    def resolve_question
      question.resolved! if question.pending?
    end

    def message(action)
      { type: model_name.to_s, id: parent_id, event: action, title: title, body: body, taskable_id: taskable_id, taskable_type: taskable_type }
    end
  end
end
