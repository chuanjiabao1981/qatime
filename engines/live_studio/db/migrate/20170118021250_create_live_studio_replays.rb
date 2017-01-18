class CreateLiveStudioReplays < ActiveRecord::Migration
  def change
    create_table :live_studio_replays do |t|
      t.references :lesson
      t.string :name
      t.string :vids
      t.integer :video_for

      t.timestamps null: false
    end
  end
end
