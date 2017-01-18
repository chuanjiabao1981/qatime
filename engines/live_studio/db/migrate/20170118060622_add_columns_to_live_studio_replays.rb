class AddColumnsToLiveStudioReplays < ActiveRecord::Migration
  def change
    add_column :live_studio_replays, :duration, :integer, default: 0
    add_column :live_studio_replays, :type_id, :string
    add_column :live_studio_replays, :snapshot_url, :string
    add_column :live_studio_replays, :orig_url, :string
    add_column :live_studio_replays, :download_orig_url, :string
    add_column :live_studio_replays, :initial_size, :string
    add_column :live_studio_replays, :sd_mp4_url, :string
    add_column :live_studio_replays, :download_sd_mp4_url, :string
    add_column :live_studio_replays, :sd_mp4_size, :string
    add_column :live_studio_replays, :hd_mp4_url, :string
    add_column :live_studio_replays, :download_hd_mp4_url, :string
    add_column :live_studio_replays, :hd_mp4_size, :string
    add_column :live_studio_replays, :shd_mp4_url, :string
    add_column :live_studio_replays, :download_shd_mp4_url, :string
    add_column :live_studio_replays, :shd_mp4_size, :string
    add_column :live_studio_replays, :create_time, :string
  end
end
