# This migration comes from live_studio (originally 20161201033713)
class AddLiveStatusToChannels < ActiveRecord::Migration
  def change
    add_column :live_studio_channels, :live_status, :integer, default: 0
    add_column :live_studio_channels, :beat_step, :integer, default: 60
  end
end
