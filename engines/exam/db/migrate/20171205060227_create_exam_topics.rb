class CreateExamTopics < ActiveRecord::Migration
  def change
    create_table :exam_topics do |t|
      t.string :title
      t.string :attach
      t.integer :score
      t.string :answer
      t.string :answer_attach

      t.timestamps null: false
    end
  end
end
