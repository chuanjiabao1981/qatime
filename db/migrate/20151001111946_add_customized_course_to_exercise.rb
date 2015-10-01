class AddCustomizedCourseToExercise < ActiveRecord::Migration
  def change
    add_column :exercises,:customized_course_id,:integer
    Exercise.all.each do |e|
      e.customized_course_id = e.customized_tutorial.customized_course_id
      e.save
    end
  end
end
