module Entities
  module LiveStudio
    class Answer < Task
      unexpose :title
      expose :body

      expose :attachments, using: Entities::LiveStudio::Attachment # 附件
    end
  end
end
