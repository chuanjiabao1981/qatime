class AlertColumnForCashAccounts < ActiveRecord::Migration
  def change
    rename_column :payment_cash_accounts, :password, :password_digest
  end
end
