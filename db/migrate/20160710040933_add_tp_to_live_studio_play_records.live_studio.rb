# This migration comes from live_studio (originally 20160710040808)
class AddTpToLiveStudioPlayRecords < ActiveRecord::Migration
  def change
    add_column :live_studio_play_records, :tp, :string, limit: 10
  end
end
