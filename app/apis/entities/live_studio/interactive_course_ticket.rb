module Entities
  module LiveStudio
    class InteractiveCourseTicket < Ticket
      expose :product, using: Entities::LiveStudio::InteractiveCourseBase, as: :interactive_course
    end
  end
end
