# This migration comes from live_studio (originally 20170328072413)
class AddProductToLiveStudioTickets < ActiveRecord::Migration
  def change
    add_reference :live_studio_tickets, :product, polymorphic: true
  end
end
