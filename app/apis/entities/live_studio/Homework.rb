module Entities
  module LiveStudio
    class Homework < Task
      expose :tasks_count
      expose :task_items, using: Entities::LiveStudio::TaskItem, as: :items # 任务项
    end
  end
end
