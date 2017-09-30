module Entities
  module LiveStudio
    class TaskItem < Grape::Entity
      format_with(:local_timestamp, &:to_i)

      expose :id
      expose :body
      expose :parent_id
      expose :attachments, using: Entities::LiveStudio::Attachment # 附件
    end
  end
end
