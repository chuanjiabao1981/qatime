module LiveStudio
  class TaskItem < ActiveRecord::Base
    default_scope { order("id asc") }

    belongs_to :task
    belongs_to :parent, class_name: 'LiveStudio::TaskItem'
    has_many :task_items, foreign_key: 'parent_id'

    has_many :quotes, as: :quoter
    has_many :attachments, through: :quotes, class_name: 'LiveStudio::Attachment'

    accepts_nested_attributes_for :quotes

    validates :body, presence: true, if: :text_item?
    validates :body, length: { in: 2..400 }, allow_blank: true

    private

    # 文本项目, 无图片和语音
    def text_item?
      quotes.size.zero?
    end
  end
end
