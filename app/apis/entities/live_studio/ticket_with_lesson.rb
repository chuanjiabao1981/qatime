module Entities
  module LiveStudio
    class TicketWithLesson < Grape::Entity
      expose :taste do |item|
        item.ticket.taste?
      end
      expose :target, merge: true, using: Entities::LiveStudio::ScheduleLesson
    end
  end
end
