module LiveStudio
  class TicketItem < ActiveRecord::Base
    belongs_to :lesson
  end
end
