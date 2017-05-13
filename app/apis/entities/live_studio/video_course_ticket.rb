module Entities
  module LiveStudio
    class VideoCourseTicket < Grape::Entity
      expose :id
      expose :used_count
      expose :buy_count
      expose :lesson_price
      expose :ticket_items, as: :progress, if: { type: :full }, using: Entities::LiveStudio::TicketItem
      expose :product, using: Entities::LiveStudio::VideoCourseBase, as: :video_course
      expose :status
    end
  end
end
