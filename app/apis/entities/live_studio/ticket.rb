module Entities
  module LiveStudio
    class Ticket < Grape::Entity
      expose :id
      expose :used_count
      expose :buy_count
      expose :lesson_price
      expose :status
      expose :type
    end
  end
end
