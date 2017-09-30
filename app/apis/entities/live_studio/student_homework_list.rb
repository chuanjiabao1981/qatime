module Entities
  module LiveStudio
    class StudentHomeworkList < Task
      expose :correction, using: Entities::LiveStudio::Correction # 批改
      expose :task_items, using: Entities::LiveStudio::TaskItem, as: :items # 任务项
    end
  end
end
