class CreateTeachingVideos < ActiveRecord::Migration
  def change
    create_table :teaching_videos do |t|
      t.string :name
      t.string :token
      t.integer :vip_class
      t.integer :teacher_id
      t.integer :question_id
      t.integer :answer_id
      t.timestamps null: false
    end
    add_index :teaching_videos,:token
  end
end
