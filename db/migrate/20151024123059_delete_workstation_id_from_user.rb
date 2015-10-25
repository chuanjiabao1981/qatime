class DeleteWorkstationIdFromUser < ActiveRecord::Migration
  def change
    remove_column :users,:workstation_id,:integer
  end
end
