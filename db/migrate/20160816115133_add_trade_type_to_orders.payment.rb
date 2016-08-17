# This migration comes from payment (originally 20160816114650)
class AddTradeTypeToOrders < ActiveRecord::Migration
  def change
    add_column :payment_orders, :trade_type, :string, limit: 16, default: 'NATIVE'
  end
end
