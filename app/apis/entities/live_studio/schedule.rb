module Entities
  module LiveStudio

    class Schedule < Grape::Entity
      expose :date
      expose :lessons, using: Entities::LiveStudio::Lesson
    end
  end
end
