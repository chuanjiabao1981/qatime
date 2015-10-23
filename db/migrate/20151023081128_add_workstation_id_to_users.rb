class AddWorkstationIdToUsers < ActiveRecord::Migration
  def change
    add_column :users,:workstation_id,:integer
  end
end
