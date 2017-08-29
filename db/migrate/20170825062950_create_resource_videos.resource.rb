# This migration comes from resource (originally 20170825055556)
class CreateResourceVideos < ActiveRecord::Migration
  def change
    create_table :resource_videos do |t|
      t.string :file
      t.integer :duration
      t.string :capture

      t.timestamps null: false
    end
  end
end
