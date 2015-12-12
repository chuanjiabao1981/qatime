class ChangeMoneyTypeFromAccount < ActiveRecord::Migration
  def change
    change_column :accounts, :money, :float
  end
end