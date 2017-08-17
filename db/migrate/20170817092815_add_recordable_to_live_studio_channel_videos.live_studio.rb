# This migration comes from live_studio (originally 20170817092723)
class AddRecordableToLiveStudioChannelVideos < ActiveRecord::Migration
  def change
    add_reference :live_studio_channel_videos, :recordable, polymorphic: true
  end
end
