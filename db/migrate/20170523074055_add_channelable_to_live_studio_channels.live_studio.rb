# This migration comes from live_studio (originally 20170523073938)
class AddChannelableToLiveStudioChannels < ActiveRecord::Migration
  def change
    add_references :live_studio, :channelable, polymorphic: true, index: true
  end
end
