# This migration comes from payment (originally 20161108064248)
class AddPaymentPasswordToCashAccounts < ActiveRecord::Migration
  def change
    add_column :payment_cash_accounts, :password, :string
  end
end
