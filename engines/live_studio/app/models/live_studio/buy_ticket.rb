module LiveStudio
  class BuyTicket < Ticket
    belongs_to :course, counter_cache: true

    after_create :instance_items
    def instance_items
      ticket_items.create(course.lessons.where(live_end_at: nil).map { |l| { lesson_id: l.id } })
    end
  end
end
