module LiveStudio
  # 回答
  class Answer < Task
    belongs_to :question, foreign_key: 'parent_id'
    has_many :quotes, as: :quoter
    has_many :attachments, through: :quotes, class_name: 'LiveStudio::Attachment'
    accepts_nested_attributes_for :quotes

    validates :body, presence: true, if: :text_item?
    validates :body, length: { in: 2..200 }, allow_blank: true

    after_commit :asyn_send_team_message, on: :create

    after_create :resolve_question
    def resolve_question
      if question.pending?
        question.resolve!
        feeds('create')
      else
        feeds('update')
      end
    end

    def message(action)
      { type: model_name.to_s, id: parent_id, event: action, title: title, body: body, taskable_id: taskable_id, taskable_type: taskable_type }
    end

    def raw_body
      body.to_s.gsub(/\r\n/, '<br />').gsub(/\n/, '<br />')
    end

    private

    # 文本项目, 无图片和语音
    def text_item?
      quotes.size.zero?
    end

    def feeds(event)
      Social::Feed.transaction do
        # 生成动态
        feed = Social::CourseQuestionFeed.create!(feedable: self, event: event, producer: user, linkable: taskable, workstation: taskable.workstation, target: question)
        # 用户发布动态
        feed.feed_publishs.create!(publisher: user)
        # 课程发布动态
        feed.feed_publishs.create!(publisher: taskable)
      end
    end
  end
end
