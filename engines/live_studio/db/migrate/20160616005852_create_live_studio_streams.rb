class CreateLiveStudioStreams < ActiveRecord::Migration
  def change
    create_table :live_studio_streams do |t|
      t.string :protocol, limit: 20
      t.string :address, limit: 255
      t.references :channel, index: true
      t.integer :user_count, default: 0
      t.string :type, limit: 100

      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
