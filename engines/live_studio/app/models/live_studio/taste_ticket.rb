module LiveStudio
  class TasteTicket < Ticket
    TASTE_COUNT = 2

    before_create :set_buy_count

    def taste?
      true
    end

    private

    def set_buy_count
      self.buy_count = TASTE_COUNT
    end
  end
end
