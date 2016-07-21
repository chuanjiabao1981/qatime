class CreateLiveStudioLiveSessions < ActiveRecord::Migration
  def change
    create_table :live_studio_live_sessions do |t|
      t.references :lesson, index: true
      t.string :token, limit: 32
      t.integer :heartbeat_count
      t.integer :duration
      t.datetime :heartbeat_at
      t.timestamps null: false
    end
  end
end
