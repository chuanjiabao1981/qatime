class AddStudentToHomework < ActiveRecord::Migration
  def up
    add_column :examinations,:student_id,:integer
    Homework.all.each do |h|
      h.student = h.customized_course.student
      h.save
    end
  end
  def down
    remove_column :examinations,:student_id,:integer
  end
end
