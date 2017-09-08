module Entities
  module LiveStudio
    class TaskItem < Grape::Entity
      format_with(:local_timestamp, &:to_i)

      expose :id
      expose :body
      expose :parent_id

    end
  end
end
