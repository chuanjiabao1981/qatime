class AddDeletedAtToTables < ActiveRecord::Migration
  def change
    add_column :recommend_items, :deleted_at, :datetime
    add_column :recommend_positions, :deleted_at, :datetime
  end
end
