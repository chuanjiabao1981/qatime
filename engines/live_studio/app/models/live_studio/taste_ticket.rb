module LiveStudio
  class TasteTicket < Ticket
    TASTE_COUNT = 2

    before_create :set_buy_count

    def taste?
      true
    end

    private

    def set_buy_count
      self.buy_count = product.try(:taste_count).to_i
      self.buy_count = 99999 if product.is_a?(VideoCourse)
    end
  end
end
