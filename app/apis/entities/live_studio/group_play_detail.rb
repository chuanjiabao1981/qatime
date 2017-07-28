module Entities
  module LiveStudio
    class GroupPlayDetail < GroupDetail
      expose :chat_team, using: Entities::Chat::Team
      expose :board_pull_stream
      expose :camera_pull_stream
    end
  end
end
