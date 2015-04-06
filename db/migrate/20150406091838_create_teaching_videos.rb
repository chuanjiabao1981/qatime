class CreateTeachingVideos < ActiveRecord::Migration
  def change
    create_table :teaching_videos do |t|
      t.string :name
      t.string :token
      t.timestamps null: false
    end
  end
end
