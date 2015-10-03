class ChangeStatusDefaultValueFromCustomizedTutorial < ActiveRecord::Migration
  def change
    change_column :customized_tutorials, :status, :string, :null => false, :default => "open"
  end
end
