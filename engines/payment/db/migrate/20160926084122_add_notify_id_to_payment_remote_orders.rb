class AddNotifyIdToPaymentRemoteOrders < ActiveRecord::Migration
  def change
    add_column :payment_remote_orders, :notify_id, :string
    add_column :payment_remote_orders, :trade_no, :string
    add_column :payment_remote_orders, :notify_time, :datetime
  end
end
