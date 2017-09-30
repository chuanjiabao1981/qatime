module LiveStudio
  class TaskItem < ActiveRecord::Base
    default_scope { order("id asc") }

    belongs_to :task
    belongs_to :parent, class_name: 'LiveStudio::TaskItem'
    has_many :task_items, foreign_key: 'parent_id'

    has_many :quotes, as: :quoter
    has_many :attachments, through: :quotes, class_name: 'LiveStudio::Attachment'

    accepts_nested_attributes_for :quotes
  end
end
