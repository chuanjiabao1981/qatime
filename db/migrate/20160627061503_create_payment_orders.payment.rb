# This migration comes from payment (originally 20160627060849)
class CreatePaymentOrders < ActiveRecord::Migration
  def change
    create_table :payment_orders do |t|
      t.string :order_no, limit: 64, null: false, uniqueness: true
      t.references :user, index: true
      t.references :product, polymorphic: true, index: true
      t.decimal :total_money, precision: 8, scale: 2, default: 0.0
      t.integer :status, default: 0, null: false
      t.integer :pay_type, default: 0, null: false
      t.string :qrcode_url
      t.string :pay_url
      t.string :remote_ip

      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
