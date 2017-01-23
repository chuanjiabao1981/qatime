class AddPaymentOrderIdToLiveStudioTickets < ActiveRecord::Migration
  def change
    add_column :live_studio_tickets, :payment_order_id, :integer
  end
end
