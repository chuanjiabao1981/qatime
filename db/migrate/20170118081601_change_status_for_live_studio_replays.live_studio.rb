# This migration comes from live_studio (originally 20170118081504)
class ChangeStatusForLiveStudioReplays < ActiveRecord::Migration
  def change
    change_column :live_studio_replays, :status, :integer, default: 0
  end
end
