module Entities
  module LiveStudio
    class LessonBase < Grape::Entity
      expose :id
      expose :name
      expose :status
    end
  end
end
