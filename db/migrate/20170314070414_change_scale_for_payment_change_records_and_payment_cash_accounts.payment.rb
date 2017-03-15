# This migration comes from payment (originally 20170314065746)
class ChangeScaleForPaymentChangeRecordsAndPaymentCashAccounts < ActiveRecord::Migration
  def change
    change_column :payment_cash_accounts, :balance, :decimal, precision: 18, scale: 3
    change_column :payment_cash_accounts, :total_income, :decimal, precision: 18, scale: 3
    change_column :payment_cash_accounts, :total_expenditure, :decimal, precision: 18, scale: 3
    change_column :payment_change_records, :different, :decimal, precision: 12, scale: 3
    change_column :payment_change_records, :before, :decimal, precision: 18, scale: 3
    change_column :payment_change_records, :after, :decimal, precision: 18, scale: 3
    change_column :payment_change_records, :amount, :decimal, precision: 18, scale: 3

    change_column :payment_billings, :total_money, :decimal, precision: 12, scale: 3
    change_column :payment_billing_items, :amount, :decimal, precision: 12, scale: 3
  end
end
