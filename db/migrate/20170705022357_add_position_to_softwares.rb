class AddPositionToSoftwares < ActiveRecord::Migration
  def change
    add_column :softwares, :position, :integer, default: 0
    add_column :software_categories, :position, :integer, default: 0
    add_index :softwares, :position
    add_index :software_categories, :position
  end
end
