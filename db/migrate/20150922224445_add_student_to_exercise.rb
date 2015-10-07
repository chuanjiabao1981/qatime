class AddStudentToExercise < ActiveRecord::Migration
  def change
    add_column :exercises,:student_id,:integer
  end
end
