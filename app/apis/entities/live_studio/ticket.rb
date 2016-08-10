module Entities
  module LiveStudio
    class Ticket < Grape::Entity
      expose :id
      expose :status
    end
  end
end
