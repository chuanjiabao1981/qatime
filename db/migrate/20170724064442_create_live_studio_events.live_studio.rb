# This migration comes from live_studio (originally 20170724061944)
class CreateLiveStudioEvents < ActiveRecord::Migration
  def change
    create_table :live_studio_events do |t|
      t.string :name, limit: 100
      t.string :type
      t.references :group, index: true
      t.references :teacher, index: true
      t.string :description
      t.integer :status, limit: 2, default: 0
      t.string :start_time, limit: 6
      t.string :end_time, limit: 6
      t.date :class_date
      t.string :class_address
      t.integer :live_count, default: 0
      t.datetime :live_start_at
      t.datetime :live_end_at
      t.integer :real_time, default: 0
      t.integer :pos, limit: 4, default: 0
      t.datetime :deleted_at

      t.timestamps null: false
      t.datetime :heartbeat_time
      t.integer  :duration
      t.integer  :replay_status,              default: 0
    end
  end
end
