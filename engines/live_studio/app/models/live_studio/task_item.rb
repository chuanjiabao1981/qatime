module LiveStudio
  class TaskItem < ActiveRecord::Base
    belongs_to :task
    belongs_to :parent, class_name: 'LiveStudio::TaskItem'
    has_many :task_items, foreign_key: 'parent_id'
  end
end
