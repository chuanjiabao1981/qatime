# This migration comes from live_studio (originally 20170110092140)
class AddColumnToChannels < ActiveRecord::Migration
  def change
    add_column :live_studio_channels, :set_always_recorded, :boolean, default: false
  end
end
