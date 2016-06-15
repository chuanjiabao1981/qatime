# This migration comes from live_studio (originally 20160615060358)
class CreateLiveStudioLiveChannels < ActiveRecord::Migration
  def change
    create_table :live_studio_live_channels do |t|
      t.string :name, limit: 200, null: false
      t.references :course, index: true
      t.string :remote_id
      t.integer :state, default: 0

      t.timestamps null: false
    end
  end
end
