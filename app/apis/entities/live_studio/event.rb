module Entities
  module LiveStudio
    class Event < Grape::Entity
      format_with(:local_timestamp, &:to_i)

      expose :id
      expose :name
      expose :class_date
      expose :start_time
      expose :end_time
      expose :status
      expose :replayable
    end
  end
end
