class AddTimestampToLiveSessions < ActiveRecord::Migration
  def change
    add_column :live_studio_live_sessions, :timestamp, :integer
  end
end
