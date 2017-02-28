class AddCodeIndexToPaymentCoupons < ActiveRecord::Migration
  def change
    add_index :payment_coupons, :code
  end
end
