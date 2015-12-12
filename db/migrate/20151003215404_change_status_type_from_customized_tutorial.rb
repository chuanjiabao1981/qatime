class ChangeStatusTypeFromCustomizedTutorial < ActiveRecord::Migration
  def change
    change_column :customized_tutorials, :status, :string
  end
end
