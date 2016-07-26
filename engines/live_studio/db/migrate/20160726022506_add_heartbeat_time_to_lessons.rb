class AddHeartbeatTimeToLessons < ActiveRecord::Migration
  def change
    add_column :live_studio_lessons, :heartbeat_time, :datetime
  end
end
