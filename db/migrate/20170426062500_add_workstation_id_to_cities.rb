class AddWorkstationIdToCities < ActiveRecord::Migration
  def change
    add_column :cities, :workstation_id, :integer
    add_index :cities, :workstation_id
  end
end
