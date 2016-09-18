# This migration comes from payment (originally 20160918065120)
class CreatePaymentRemoteOrders < ActiveRecord::Migration
  def change
    create_table :payment_remote_orders do |t|
      t.references :order, index: true
      t.string :order_no, limit: 16
      t.decimal :amount, precision: 8, scale: 2
      t.string :remote_ip, limit: 64
      t.integer :status, limit: 4

      t.timestamps null: false
    end
  end
end
