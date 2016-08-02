# This migration comes from live_studio (originally 20160726022506)
class AddHeartbeatTimeToLessons < ActiveRecord::Migration
  def change
    add_column :live_studio_lessons, :heartbeat_time, :datetime
  end
end
