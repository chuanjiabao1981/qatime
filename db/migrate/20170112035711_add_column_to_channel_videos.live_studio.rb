# This migration comes from live_studio (originally 20170112032133)
class AddColumnToChannelVideos < ActiveRecord::Migration
  def change
    add_column :live_studio_channel_videos, :lesson_id, :integer
  end
end
