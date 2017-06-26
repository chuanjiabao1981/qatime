module Entities
  module LiveStudio
    class StudentSearchSchedule < Grape::Entity
      expose :date
      expose :lessons, using: Entities::LiveStudio::TicketWithLesson
    end
  end
end
