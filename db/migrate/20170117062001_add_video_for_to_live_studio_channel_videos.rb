class AddVideoForToLiveStudioChannelVideos < ActiveRecord::Migration
  def change
    add_column :live_studio_channel_videos, :video_for, :integer, default: 0
  end
end
