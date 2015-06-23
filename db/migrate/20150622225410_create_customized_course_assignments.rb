class CreateCustomizedCourseAssignments < ActiveRecord::Migration
  def change
    create_table :customized_course_assignments do |t|
      t.integer :customized_course_id
      t.integer :teacher_id
      t.timestamps null: false
    end
  end
end
