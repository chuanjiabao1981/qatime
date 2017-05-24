module Entities
  module LiveStudio
    # 一对一直播信息
    class InteractiveCoursePlay < InteractiveCourseDetail
      expose :chat_team, using: Entities::Chat::Team
      expose :board_pull_stream
    end
  end
end
