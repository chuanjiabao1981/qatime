class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.text :content
      t.string :token
      t.integer :student_id
      t.integer :answers_count,default: 0
      t.timestamps null: false
    end
  end
end
