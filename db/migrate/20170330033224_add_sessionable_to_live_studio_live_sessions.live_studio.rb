# This migration comes from live_studio (originally 20170330033018)
class AddSessionableToLiveStudioLiveSessions < ActiveRecord::Migration
  def change
    add_reference :live_studio_live_sessions, :sessionable, polymorphic: true
  end
end
