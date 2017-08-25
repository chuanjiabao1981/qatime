class AddRecordableToLiveStudioChannelVideos < ActiveRecord::Migration
  def change
    add_reference :live_studio_channel_videos, :recordable, polymorphic: true
  end
end
