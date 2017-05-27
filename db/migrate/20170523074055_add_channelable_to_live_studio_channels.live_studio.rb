# This migration comes from live_studio (originally 20170523073938)
class AddChannelableToLiveStudioChannels < ActiveRecord::Migration
  def change
    add_reference :live_studio_channels, :channelable, polymorphic: true
  end
end
