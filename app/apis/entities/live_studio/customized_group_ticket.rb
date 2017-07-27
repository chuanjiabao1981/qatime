module Entities
  module LiveStudio
    class CustomizedGroupTicket < Ticket
      expose :product, using: Entities::LiveStudio::Group, as: :customized_group, if: { type: :full }
    end
  end
end
