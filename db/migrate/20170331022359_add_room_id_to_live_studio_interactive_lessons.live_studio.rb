# This migration comes from live_studio (originally 20170331022310)
class AddRoomIdToLiveStudioInteractiveLessons < ActiveRecord::Migration
  def change
    add_column :live_studio_interactive_lessons, :room_id, :string, limit: 64
  end
end
