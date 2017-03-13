module LiveStudio
  class BuyTicket < Ticket
    belongs_to :course, counter_cache: true
    belongs_to :payment_order, class_name: 'Payment::Order'
    belongs_to :seller, polymorphic: true

    private

    after_create :instance_items
    def instance_items
      ticket_items.create(course.lessons.where(live_end_at: nil).map { |l| { lesson_id: l.id } })
    end

    after_update :update_items_status, if: :status_changed?
    def update_items_status
      ticket_items.where(status: LiveStudio::TicketItem.statuses[:refunding]).map(&:finish!) if refunded?
      ticket_items.where(status: LiveStudio::TicketItem.statuses[:refunding]).map(&:active!) if active?
    end

    before_validation :set_seller, on: :create
    def set_seller
      self.seller = payment_order.try(:seller) || Workstation.default
      self.platform_percentage = [course.sell_and_platform_percentage, seller.platform_percentage].min
      self.sell_percentage = course.sell_and_platform_percentage - platform_percentage
    end
  end
end
