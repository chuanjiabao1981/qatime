module Entities
  module LiveStudio
    class Course < Grape::Entity
      expose :id
      expose :status
    end
  end
end
