# This migration comes from payment (originally 20161215090825)
class RemoveColumnForRemoteOrders < ActiveRecord::Migration
  def change
    remove_column :payment_remote_orders, :transaction_type
  end
end
