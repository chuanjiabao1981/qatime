class CreateLiveStudioReplays < ActiveRecord::Migration
  def change
    create_table :live_studio_replays do |t|
      t.references :lesson
      t.references :channel
      t.string :name
      t.string :vids
      t.integer :video_for
      t.string :vid
      t.string :orig_video_key
      t.string :uid
      t.string :n_id
      t.integer :status
      t.timestamps null: false
    end
  end
end
