module Entities
  module LiveStudio
    class InteractiveLesson < Grape::Entity
      expose :id
      expose :name
      expose :teacher, using: Entities::Teacher, if: { type: :full }
    end
  end
end
