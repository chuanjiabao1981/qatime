module Entities
  module LiveStudio
    class Correction < Task
      expose :task_items, using: Entities::LiveStudio::TaskItem, as: :items # 任务项
    end
  end
end
