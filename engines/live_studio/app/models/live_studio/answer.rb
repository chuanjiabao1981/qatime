module LiveStudio
  # 回答
  class Answer < Task
    belongs_to :question, foreign_key: 'parent_id'
  end
end
