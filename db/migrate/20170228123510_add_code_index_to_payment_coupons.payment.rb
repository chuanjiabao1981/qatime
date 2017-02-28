# This migration comes from payment (originally 20170228123422)
class AddCodeIndexToPaymentCoupons < ActiveRecord::Migration
  def change
    add_index :payment_coupons, :code
  end
end
