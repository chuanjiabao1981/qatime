module Entities
  module LiveStudio
    class Course < Grape::Entity
      expose :name
      expose :description
    end
  end
end
