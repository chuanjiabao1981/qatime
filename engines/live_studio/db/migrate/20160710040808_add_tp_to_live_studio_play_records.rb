class AddTpToLiveStudioPlayRecords < ActiveRecord::Migration
  def change
    add_column :live_studio_play_records, :tp, :string, limit: 10
  end
end
