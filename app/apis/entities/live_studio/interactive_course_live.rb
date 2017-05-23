module Entities
  module LiveStudio
    # 一对一直播信息
    class InteractiveCourseLive < InteractiveCourseBase
      expose :chat_team
      expose :board_push_stream
    end
  end
end
