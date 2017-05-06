class AddSessionableToLiveStudioLiveSessions < ActiveRecord::Migration
  def change
    add_reference :live_studio_live_sessions, :sessionable, polymorphic: true
  end
end
