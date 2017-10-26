module LiveStudio
  class BuyTicket < Ticket
    belongs_to :product, polymorphic: true
    belongs_to :payment_order, class_name: 'Payment::Order'
    belongs_to :seller, polymorphic: true

    private

    def update_items_status
      ticket_items.where(status: LiveStudio::TicketItem.statuses[:refunding]).map(&:finish!) if refunded?
      ticket_items.where(status: LiveStudio::TicketItem.statuses[:refunding]).map(&:active!) if active?
    end

    before_validation :set_seller, on: :create
    def set_seller
      self.seller = payment_order.try(:seller) || Workstation.default
      self.platform_percentage = [product.sell_and_platform_percentage, seller.platform_percentage].min
      self.sell_percentage = product.sell_and_platform_percentage - platform_percentage
    end

    after_create :ince_user_counter
    # 增加购买人数
    def ince_user_counter
      product.inc_buy_tickets_count
    end
  end
end
