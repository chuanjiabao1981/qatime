module Entities
  module LiveStudio
    class GroupLiveDetail < GroupDetail
      expose :chat_team, using: Entities::Chat::Team
      expose :board_push_stream
      expose :camera_push_stream
    end
  end
end
