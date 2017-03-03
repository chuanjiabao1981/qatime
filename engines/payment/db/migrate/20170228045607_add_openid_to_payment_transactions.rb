class AddOpenidToPaymentTransactions < ActiveRecord::Migration
  def change
    add_column :payment_transactions, :openid, :string
  end
end
