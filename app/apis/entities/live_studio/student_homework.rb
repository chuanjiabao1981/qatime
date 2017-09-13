module Entities
  module LiveStudio
    class StudentHomework < Task
      expose :correction, using: Entities::LiveStudio::Correction # 批改
      expose :homework, using: Entities::LiveStudio::Homework # 作业
      expose :task_items, using: Entities::LiveStudio::TaskItem, as: :items # 任务项
    end
  end
end
