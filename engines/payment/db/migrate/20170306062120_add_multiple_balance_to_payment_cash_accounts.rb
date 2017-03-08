class AddMultipleBalanceToPaymentCashAccounts < ActiveRecord::Migration
  def change
    add_column :payment_cash_accounts, :available_balance, :decimal, precision: 16, scale: 2 # 可提现余额
    add_column :payment_cash_accounts, :deposit_balance, :decimal, precision: 16, scale: 2 # 保证金
    add_column :payment_cash_accounts, :unavailable_balance, :decimal, precision: 16, scale: 2 # 不可提现金额
  end
end
