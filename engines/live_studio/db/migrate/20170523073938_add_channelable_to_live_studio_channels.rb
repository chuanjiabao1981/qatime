class AddChannelableToLiveStudioChannels < ActiveRecord::Migration
  def change
    add_reference :live_studio_channels, :channelable, polymorphic: true
  end
end
