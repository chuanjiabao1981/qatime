class AddTargetRefToReplays < ActiveRecord::Migration
  def change
    add_reference :live_studio_replays, :target, index: true, polymorphic: true
    add_reference :live_studio_channel_videos, :target, index: true, polymorphic: true
  end
end