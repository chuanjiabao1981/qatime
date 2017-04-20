class ChangeColumnDefaultToPaymentCashAccounts < ActiveRecord::Migration
  def self.up
    change_column_default :payment_cash_accounts, :deposit_balance, 0.0
    remove_column :payment_cash_accounts, :available_balance
    remove_column :payment_cash_accounts, :unavailable_balance
  end

  def self.down
    change_column_default :payment_cash_accounts, :deposit_balance, nil
    add_column :payment_cash_accounts, :available_balance, :decimal, precision: 16, scale: 2 # 可提现余额
    add_column :payment_cash_accounts, :unavailable_balance, :decimal, precision: 16, scale: 2 # 不可提现金额
  end
end
