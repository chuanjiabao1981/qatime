class ChangeAccountsToPolymorphic < ActiveRecord::Migration
  def change
    remove_column :accounts,:user_id,:integer
    add_column :accounts,:accountable_id,:integer
    add_column :accounts,:accountable_type,:string
    add_column :accounts,:total_income,:integer
    add_column :accounts,:total_expenditure,:integer
  end
end
