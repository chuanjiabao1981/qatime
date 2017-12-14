class CreateExamAnswers < ActiveRecord::Migration
  def change
    create_table :exam_answers do |t|
      t.references :result, index: true
      t.reference :topic
      t.string :content
      t.string :attach
      t.integer :result
      t.decimal :score, precision: 5, scale: 2

      t.timestamps null: false
    end
  end
end
