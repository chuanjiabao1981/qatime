class AddPasswordSetAtToCashAccounts < ActiveRecord::Migration
  def change
    add_column :payment_cash_accounts, :password_set_at, :timestamp
  end
end
