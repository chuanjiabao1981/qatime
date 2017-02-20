class AddWechatUserToPaymentTransactions < ActiveRecord::Migration
  def change
    add_reference :payment_transactions, :wechat_user
  end
end
