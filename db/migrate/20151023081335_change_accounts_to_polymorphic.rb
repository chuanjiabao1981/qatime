class ChangeAccountsToPolymorphic < ActiveRecord::Migration
  def change
    rename_column :accounts,:user_id,:accountable_id
    add_column :accounts,:accountable_type,:string
    add_column :accounts,:total_income,:integer
    add_column :accounts,:total_expenditure,:integer
  end
end
