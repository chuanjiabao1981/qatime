class AddNidToChannelVideos < ActiveRecord::Migration
  def change
    add_column :live_studio_channel_videos, :nid, :string
  end
end
