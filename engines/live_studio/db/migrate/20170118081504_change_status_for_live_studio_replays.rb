class ChangeStatusForLiveStudioReplays < ActiveRecord::Migration
  def change
    change_column :live_studio_replays, :status, :integer, default: 0
  end
end
