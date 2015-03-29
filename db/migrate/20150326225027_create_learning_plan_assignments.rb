class CreateLearningPlanAssignments < ActiveRecord::Migration
  def change
    create_table :learning_plan_assignments do |t|
      t.integer :learning_plan_id
      t.integer :teacher_id
      t.timestamps null: false
    end
  end
end
