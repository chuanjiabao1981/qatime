class CreateExcercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.string  :token
      t.string  :title
      t.string  :content
      t.integer :teacher_id
      t.integer :customized_tutorial_id
      t.integer :solutions_count,default: 0
      t.timestamps null: false
    end
    add_column :customized_tutorials,:exercises_count,:integer,default: 0
  end
end
