class AddPaymentPasswordToCashAccounts < ActiveRecord::Migration
  def change
    add_column :payment_cash_accounts, :password, :string
  end
end
