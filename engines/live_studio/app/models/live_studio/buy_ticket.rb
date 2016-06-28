module LiveStudio
  class BuyTicket < Ticket
    TASTE_COUNT = 2

    before_create :set_buy_count

    private

    def set_buy_count
      self.buy_count = TASTE_COUNT
    end
  end
end
