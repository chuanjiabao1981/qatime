# This migration comes from payment (originally 20170309023658)
class AddTypeToPaymentCashAccounts < ActiveRecord::Migration
  def change
    add_column :payment_cash_accounts, :type, :string
  end
end
