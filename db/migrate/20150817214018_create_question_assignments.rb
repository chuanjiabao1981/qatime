class CreateQuestionAssignments < ActiveRecord::Migration
  def change
    create_table :question_assignments do |t|
      t.integer :question_id
      t.integer :teacher_id
      t.timestamps null: false
    end
  end
end
