class AddPayAtToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :pay_at, :datetime
  end
end
