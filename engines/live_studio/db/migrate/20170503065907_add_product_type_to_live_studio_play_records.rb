class AddProductTypeToLiveStudioPlayRecords < ActiveRecord::Migration
  def change
    add_column :live_studio_play_records, :product_id, :integer
    add_column :live_studio_play_records, :product_type, :string
    add_index :live_studio_play_records, [:product_id, :product_type]
  end
end
