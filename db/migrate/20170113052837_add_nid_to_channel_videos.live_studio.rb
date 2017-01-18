# This migration comes from live_studio (originally 20170113052646)
class AddNidToChannelVideos < ActiveRecord::Migration
  def change
    add_column :live_studio_channel_videos, :nid, :string
  end
end
