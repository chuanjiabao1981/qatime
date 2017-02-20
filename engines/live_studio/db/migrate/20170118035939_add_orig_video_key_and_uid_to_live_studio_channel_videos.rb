class AddOrigVideoKeyAndUidToLiveStudioChannelVideos < ActiveRecord::Migration
  def change
    add_column :live_studio_channel_videos, :orig_video_key, :string
    add_column :live_studio_channel_videos, :uid
  end
end
