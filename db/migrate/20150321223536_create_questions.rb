class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.text :content
      t.string :token
      t.integer :student_id
      t.integer :answers_count,default: 0
      t.integer :vip_class_id
      t.integer :learning_plan_id
      t.jsonb   :infos, null:false, default: '{}'
      t.timestamps null: false
    end
    add_index :questions,:infos, using: :gin
  end
end
