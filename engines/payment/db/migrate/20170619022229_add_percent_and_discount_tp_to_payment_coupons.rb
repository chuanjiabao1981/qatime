class AddPercentAndDiscountTpToPaymentCoupons < ActiveRecord::Migration
  def change
    add_column :payment_coupons, :percent, :decimal, precision: 4, scale: 2, default: 0
    add_column :payment_coupons, :discount_tp, :integer, default: 0
  end
end
