# This migration comes from live_studio (originally 20170112101035)
class AddColumnToPlayRecords < ActiveRecord::Migration
  def change
    add_column :live_studio_play_records, :play_type, :integer, default: 0
  end
end
