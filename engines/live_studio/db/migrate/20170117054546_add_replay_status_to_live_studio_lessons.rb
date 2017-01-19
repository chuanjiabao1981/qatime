class AddReplayStatusToLiveStudioLessons < ActiveRecord::Migration
  def change
    add_column :live_studio_lessons, :replay_status, :integer, default: 0
  end
end
