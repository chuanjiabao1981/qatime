class AddColumnsToRemoteOrders < ActiveRecord::Migration
  def change
    add_column :payment_remote_orders, :remote_params_hash, :text
    add_column :payment_remote_orders, :result_params_hash, :text
    add_column :payment_remote_orders, :transaction_type, :integer, default: 0
  end
end
