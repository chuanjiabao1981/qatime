class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :question_id
      t.integer :teacher_id
      t.string  :token
      t.text :content
      t.timestamps null: false
    end
  end
end
