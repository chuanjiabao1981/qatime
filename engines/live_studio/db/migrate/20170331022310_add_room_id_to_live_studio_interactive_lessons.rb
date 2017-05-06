class AddRoomIdToLiveStudioInteractiveLessons < ActiveRecord::Migration
  def change
    add_column :live_studio_interactive_lessons, :room_id, :string, limit: 64
  end
end
