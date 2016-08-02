module Entities
  module LiveStudio
    class Course < Grape::Entity
      expose :id
      expose :name
    end
  end
end
