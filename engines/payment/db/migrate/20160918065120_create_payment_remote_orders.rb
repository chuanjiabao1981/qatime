class CreatePaymentRemoteOrders < ActiveRecord::Migration
  def change
    create_table :payment_remote_orders do |t|
      t.references :order, polymorphic: true, index: true
      t.string :order_no, limit: 64
      t.decimal :amount, precision: 8, scale: 2
      t.string :remote_ip, limit: 64
      t.string :trade_type, limit: 32
      t.string :pay_url
      t.string :type, limit: 128
      t.integer :status, limit: 4
      t.string :prepay_id
      t.text :nonce_str
      t.datetime :pay_at

      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
