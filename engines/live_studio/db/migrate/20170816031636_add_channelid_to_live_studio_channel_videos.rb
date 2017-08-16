class AddChannelidToLiveStudioChannelVideos < ActiveRecord::Migration
  def change
    add_column :live_studio_channel_videos, :channelid, :string # 音视频录制id

    add_index :live_studio_channel_videos, :channelid
  end
end
