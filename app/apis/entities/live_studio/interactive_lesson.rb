module Entities
  module LiveStudio
    class InteractiveLesson < Grape::Entity
      expose :id
      expose :name
      expose :class_date
      expose :start_time
      expose :end_time
      expose :status
      expose :teacher, using: Entities::Teacher, if: { type: :full }
    end
  end
end
