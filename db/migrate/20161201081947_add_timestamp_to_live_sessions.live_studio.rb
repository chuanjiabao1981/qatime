# This migration comes from live_studio (originally 20161201081336)
class AddTimestampToLiveSessions < ActiveRecord::Migration
  def change
    add_column :live_studio_live_sessions, :timestamp, :integer
  end
end
