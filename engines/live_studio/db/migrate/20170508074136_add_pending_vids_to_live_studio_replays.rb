class AddPendingVidsToLiveStudioReplays < ActiveRecord::Migration
  def change
    add_column :live_studio_replays, :pending_vids, :string
  end
end
