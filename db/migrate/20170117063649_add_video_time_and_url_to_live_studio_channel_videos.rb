class AddVideoTimeAndUrlToLiveStudioChannelVideos < ActiveRecord::Migration
  def change
    add_column :live_studio_channel_videos, :url, :string
    add_column :live_studio_channel_videos, :begin_time, :string
    add_column :live_studio_channel_videos, :end_time, :string

  end
end
