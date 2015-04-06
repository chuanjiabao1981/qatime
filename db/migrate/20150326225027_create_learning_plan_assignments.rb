class CreateLearningPlanAssignments < ActiveRecord::Migration
  def change
    create_table :learning_plan_assignments do |t|
      t.integer :learning_plan_id
      t.integer :teacher_id
      t.integer :answered_questions_count,default:0
      t.timestamps null: false
    end
    add_index :learning_plan_assignments,[:learning_plan_id,:teacher_id],:unique => true,name: "unique_teacher"
  end
end
