module Entities
  module LiveStudio
    class CourseTicket < Grape::Entity
      expose :id
      expose :used_count
      expose :buy_count
      expose :lesson_price
      expose :ticket_items, as: :progress, if: { type: :full }, using: Entities::LiveStudio::CourseTicketItem
      expose :product, using: Entities::LiveStudio::CourseBase, as: :course
      expose :status
      expose :type
    end
  end
end
