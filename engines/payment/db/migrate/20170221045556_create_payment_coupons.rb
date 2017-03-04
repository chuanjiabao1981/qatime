class CreatePaymentCoupons < ActiveRecord::Migration
  def change
    create_table :payment_coupons do |t|
      t.references :owner, polymorphic: true, index: true
      t.string :code
      t.decimal :price, precision: 8, scale: 2, default: 0.0

      t.timestamps null: false
    end

    add_column :payment_transactions, :coupon_id, :integer
    add_index :payment_transactions, :coupon_id
  end
end
