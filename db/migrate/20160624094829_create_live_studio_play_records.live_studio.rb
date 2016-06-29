# This migration comes from live_studio (originally 20160624092232)
class CreateLiveStudioPlayRecords < ActiveRecord::Migration
  def change
    create_table :live_studio_play_records do |t|
      t.references :user, index: true
      t.references :course, index: true
      t.references :lesson, index: true
      t.references :ticket, index: true

      t.datetime :start_time_at
      t.datetime :end_time_at

      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
