class AddChannelableToLiveStudioChannels < ActiveRecord::Migration
  def change
    add_references :live_studio, :channelable, polymorphic: true, index: true
  end
end
