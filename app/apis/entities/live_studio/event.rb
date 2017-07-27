module Entities
  module LiveStudio
    class Event < Grape::Entity
      expose :id
      expose :name
      expose :class_date
      expose :start_time
      expose :end_time
      expose :status
    end
  end
end
