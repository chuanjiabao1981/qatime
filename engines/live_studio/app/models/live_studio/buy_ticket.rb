module LiveStudio
  class BuyTicket < Ticket
    belongs_to :course, counter_cache: true
  end
end
