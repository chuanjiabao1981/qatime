module Entities
  module LiveStudio
    class InteractiveCourse < Grape::Entity
      expose :id
      expose :name
      expose :subject
      expose :grade
      expose :price
      expose :status
      expose :description
      expose :class_date
      expose :start_at
      expose :end_at
      expose :teacher, using: Entities::Teacher, if: { type: :full }
    end
  end
end
