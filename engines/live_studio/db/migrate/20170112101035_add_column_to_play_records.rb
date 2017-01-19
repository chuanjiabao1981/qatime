class AddColumnToPlayRecords < ActiveRecord::Migration
  def change
    add_column :live_studio_play_records, :play_type, :integer, default: 0
  end
end
