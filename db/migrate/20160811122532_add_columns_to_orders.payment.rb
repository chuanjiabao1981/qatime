# This migration comes from payment (originally 20160811122212)
class AddColumnsToOrders < ActiveRecord::Migration
  def change
    add_column :payment_orders, :prepayid, :string
    add_column :payment_orders, :noncestr, :string
  end
end
