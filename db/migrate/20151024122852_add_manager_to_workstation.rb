class AddManagerToWorkstation < ActiveRecord::Migration
  def change
    add_column :workstations,:manager_id,:integer
  end
end
