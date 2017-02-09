# This migration comes from payment (originally 20170209032042)
class AddWechatUserToPaymentTransactions < ActiveRecord::Migration
  def change
    add_reference :payment_transactions, :wechat_user
  end
end
