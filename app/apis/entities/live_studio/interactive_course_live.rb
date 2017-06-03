module Entities
  module LiveStudio
    # 一对一直播信息
    class InteractiveCourseLive < InteractiveCourseDetail
      expose :chat_team, using: Entities::Chat::Team
      expose :board_push_stream
    end
  end
end
