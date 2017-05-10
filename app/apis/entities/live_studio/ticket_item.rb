module Entities
  module LiveStudio
    class TicketItem < Grape::Entity
      expose :target, as: :video_lesson, using: Entities::LiveStudio::VideoLessonPlay
      expose :status
    end
  end
end
