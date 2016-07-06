module LiveStudio
  class TasteTicket < Ticket
    TASTE_COUNT = 2

    before_create :set_buy_count
    after_create :set_chat_account

    def taste?
      true
    end

    private

    def set_buy_count
      self.buy_count = TASTE_COUNT
    end

    def set_chat_account
      return if student.chat_account.present?

      student.create_chat_account(
        accid: SecureRandom.hex(32)
      )
    end

  end
end
