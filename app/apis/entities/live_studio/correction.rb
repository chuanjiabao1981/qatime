module Entities
  module LiveStudio
    class Correction < Task
      expose :task_items, using: Entities::LiveStudio::TaskItem, as: :items # 任务项

      after_commit :asyn_send_task_message, on: :create
    end
  end
end
