class AddTypeToPaymentCashAccounts < ActiveRecord::Migration
  def change
    add_column :payment_cash_accounts, :type, :string
  end
end
