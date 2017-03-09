class AddCrossRegionPercentageToWorkstations < ActiveRecord::Migration
  def change
    add_column :workstations, :cross_region_percentage, :integer, default: 10
  end
end
