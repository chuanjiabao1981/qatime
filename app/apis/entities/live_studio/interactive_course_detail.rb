module Entities
  module LiveStudio
    # 一对一直播信息
    class InteractiveCourseDetail < InteractiveCourseBase
      expose :order_lessons, as: :interactive_lessons, using: Entities::LiveStudio::InteractiveLesson
    end
  end
end
