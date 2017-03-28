class AddProductToLiveStudioTickets < ActiveRecord::Migration
  def change
    add_reference :live_studio_tickets, :product, polymorphic: true
  end
end
