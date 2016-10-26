# This migration comes from live_studio (originally 20161026020036)
class AddUseForToLiveStudioChannels < ActiveRecord::Migration
  def change
    add_column :live_studio_channels, :use_for, :integer, default: 0
  end
end
