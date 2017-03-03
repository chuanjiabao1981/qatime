class AddSellerToLiveStudioTickets < ActiveRecord::Migration
  def change
    add_reference :live_studio_tickets, :seller, polymorphic: true
  end
end
