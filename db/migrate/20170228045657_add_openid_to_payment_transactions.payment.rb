# This migration comes from payment (originally 20170228045607)
class AddOpenidToPaymentTransactions < ActiveRecord::Migration
  def change
    add_column :payment_transactions, :openid, :string
  end
end
