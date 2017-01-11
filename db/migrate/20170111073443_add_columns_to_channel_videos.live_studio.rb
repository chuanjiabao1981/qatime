class AddColumnsToChannelVideos < ActiveRecord::Migration
  def change

    add_column :live_studio_channel_videos, :duration, :string
    add_column :live_studio_channel_videos, :type_id, :string
    add_column :live_studio_channel_videos, :snapshot_url, :string

    add_column :live_studio_channel_videos, :orig_url, :string
    add_column :live_studio_channel_videos, :download_orig_url, :string
    add_column :live_studio_channel_videos, :initial_size, :string

    add_column :live_studio_channel_videos, :sd_mp4_url, :string
    add_column :live_studio_channel_videos, :download_sd_mp4_url, :string
    add_column :live_studio_channel_videos, :sd_mp4_size, :string

    add_column :live_studio_channel_videos, :hd_mp4_url, :string
    add_column :live_studio_channel_videos, :download_hd_mp4_url, :string
    add_column :live_studio_channel_videos, :hd_mp4_size, :string

    add_column :live_studio_channel_videos, :shd_mp4_url, :string
    add_column :live_studio_channel_videos, :download_shd_mp4_url, :string
    add_column :live_studio_channel_videos, :shd_mp4_size, :string

    add_column :live_studio_channel_videos, :create_time, :string
  end
end
