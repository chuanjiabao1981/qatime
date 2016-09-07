# This migration comes from payment (originally 20160902064830)
class AddPayAtToOrders < ActiveRecord::Migration
  def change
    add_column :payment_orders, :pay_at, :datetime
  end
end
