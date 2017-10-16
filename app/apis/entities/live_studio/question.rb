module Entities
  module LiveStudio
    class Question < Task
      expose :body
      expose :answer, using: Entities::LiveStudio::Answer # 回答
      expose :attachments, using: Entities::LiveStudio::Attachment # 附件
    end
  end
end
