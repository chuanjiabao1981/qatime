module Entities
  module LiveStudio
    class Task < Grape::Entity
      format_with(:local_timestamp, &:to_i)

      expose :id
      expose :title
      expose :parent_id
      expose :status
      expose :user_id
      expose :user_name

      with_options(format_with: :local_timestamp) do
        expose :created_at
      end
      expose :task_items, using: Entities::LiveStudio::TaskItem, as: :items # 任务项
      expose :model_name
    end
  end
end
