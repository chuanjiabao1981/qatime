# This migration comes from live_studio (originally 20170818070749)
class AddAppKeyAndAppSecretToLiveStudioVideos < ActiveRecord::Migration
  def change
    add_column :live_studio_channel_videos, :app_key, :string, limit: 128
    add_column :live_studio_channel_videos, :app_secret, :string, limit: 128

    LiveStudio::ChannelVideo.includes(:target).each do |video|
      app = video.target.is_a?(LiveStudio::InteractiveLesson) ? NeteaseSettings : VCloud
      video.app_key = app.app_key
      video.app_secret = app.app_secret
      video.save
    end
  end
end
