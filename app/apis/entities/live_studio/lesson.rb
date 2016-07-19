module Entities
  module LiveStudio
    class Lesson < Grape::Entity
      expose :name
      expose :status_text
      expose :class_date
      expose :live_time
    end
  end
end
