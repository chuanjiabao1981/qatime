class AddBillingPercentageToWorkstations < ActiveRecord::Migration
  def change
    add_column :workstations, :publish_percentage, :integer, default: 5
    add_column :workstations, :system_percentage, :integer, default: 0
  end
end
