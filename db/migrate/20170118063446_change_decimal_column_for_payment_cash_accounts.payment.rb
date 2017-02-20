# This migration comes from payment (originally 20170118063316)
class ChangeDecimalColumnForPaymentCashAccounts < ActiveRecord::Migration
  def change
    change_column :payment_cash_accounts, :balance, :decimal, precision: 12, scale: 2
    change_column :payment_cash_accounts, :total_income, :decimal, precision: 12, scale: 2
    change_column :payment_cash_accounts, :total_expenditure, :decimal, precision: 12, scale: 2
    change_column :payment_cash_accounts, :frozen_balance, :decimal, precision: 12, scale: 2
  end
end
