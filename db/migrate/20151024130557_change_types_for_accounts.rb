class ChangeTypesForAccounts < ActiveRecord::Migration
  def change
    change_column :accounts, :total_income, :float, :null => false, :default => 0
    change_column :accounts, :total_expenditure, :float, :null => false, :default => 0
  end
end
