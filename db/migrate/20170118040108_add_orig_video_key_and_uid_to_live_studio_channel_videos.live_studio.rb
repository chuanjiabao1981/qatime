# This migration comes from live_studio (originally 20170118035939)
class AddOrigVideoKeyAndUidToLiveStudioChannelVideos < ActiveRecord::Migration
  def change
    add_column :live_studio_channel_videos, :orig_video_key, :string
    add_column :live_studio_channel_videos, :uid, :string
  end
end
