# This migration comes from payment (originally 20161214122304)
class RenameColumnForRemoteOrders < ActiveRecord::Migration
  def change
    rename_column :payment_remote_orders, :remote_params_hash, :hold_remotes
    rename_column :payment_remote_orders, :result_params_hash, :hold_results
  end
end
