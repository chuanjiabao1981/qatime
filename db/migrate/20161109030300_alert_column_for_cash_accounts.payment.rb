# This migration comes from payment (originally 20161109024459)
class AlertColumnForCashAccounts < ActiveRecord::Migration
  def change
    rename_column :payment_cash_accounts, :password, :password_digest
  end
end
