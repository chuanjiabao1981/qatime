# This migration comes from live_studio (originally 20170508074136)
class AddPendingVidsToLiveStudioReplays < ActiveRecord::Migration
  def change
    add_column :live_studio_replays, :pending_vids, :string
  end
end
