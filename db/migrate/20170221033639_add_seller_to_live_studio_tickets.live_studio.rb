# This migration comes from live_studio (originally 20170221033516)
class AddSellerToLiveStudioTickets < ActiveRecord::Migration
  def change
    add_reference :live_studio_tickets, :seller, polymorphic: true
  end
end
