class AddIncomeAndExpenditureToCashAccounts < ActiveRecord::Migration
  def change
    add_column :payment_cash_accounts, :total_income, :decimal, precision: 8, scale: 2, default: 0
    add_column :payment_cash_accounts, :total_expenditure, :decimal, precision: 8, scale: 2, default: 0
    add_column :payment_cash_accounts, :migrated, :boolean, default: false
  end
end

