# This migration comes from payment (originally 20170106015153)
class AddPasswordSetAtToCashAccounts < ActiveRecord::Migration
  def change
    add_column :payment_cash_accounts, :password_set_at, :timestamp
  end
end
