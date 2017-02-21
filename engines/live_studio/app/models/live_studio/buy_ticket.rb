module LiveStudio
  class BuyTicket < Ticket
    belongs_to :course, counter_cache: true
    belongs_to :payment_order, class_name: 'Payment::Order'
    belongs_to :sell_channel
    belongs_to :channel_owner, polymorphic: true
    belongs_to :seller, polymorphic: true

    private

    after_create :instance_items
    def instance_items
      ticket_items.create(course.lessons.where(live_end_at: nil).map { |l| { lesson_id: l.id } })
    end

    after_update :update_items_status, if: :status_changed?
    def update_items_status
      ticket_items.where(status: LiveStudio::TicketItem.statuses[:refunding]).map(&:refunded!) if refunded?
      ticket_items.where(status: LiveStudio::TicketItem.statuses[:refunding]).map(&:unused!) if active?
    end
  end
end
