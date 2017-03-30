module Entities
  module LiveStudio
    class InteractiveTicket < Grape::Entity
      expose :id
      expose :type
      expose :status
      expose :interactive_course, using: Entities::LiveStudio::InteractiveCourse
    end
  end
end
