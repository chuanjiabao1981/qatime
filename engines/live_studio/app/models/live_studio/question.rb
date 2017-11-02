module LiveStudio
  # 提问
  class Question < Task
    extend Enumerize
    include AASM

    enum status: { pending: 0, resolved: 2 }
    enumerize :status, in: { pending: 0, resolved: 2 }, default: :pending

    aasm column: :status, enum: true do
      state :pending, initial: true
      state :resolved

      event :resolve do
        before do
          self.resolved_at = Time.now
        end
        transitions from: :pending, to: :resolved
      end
    end

    has_one :answer, foreign_key: 'parent_id'
    has_many :answers, foreign_key: 'parent_id'
    belongs_to :teacher, class_name: '::Teacher'

    has_many :quotes, as: :quoter
    has_many :attachments, through: :quotes, class_name: 'LiveStudio::Attachment'
    accepts_nested_attributes_for :quotes

    validates :title, presence: true, length: { in: 2..20 }

    validates :body, presence: true, if: :text_item?
    validates :body, length: { in: 2..200 }, allow_blank: true

    after_commit :asyn_send_team_message, on: :create
   
    def raw_body
      body.to_s.gsub(/\r\n/, '<br />').gsub(/\n/, '<br />')
    end

    private

    before_validation :set_teacher
    def set_teacher
      self.teacher ||= taskable.teacher
    end

    # 文本项目, 无图片和语音
    def text_item?
      quotes.size.zero?
    end
  end
end
