class AddCourseIdAndLessonId < ActiveRecord::Migration
  def change
    add_column :covers,:course_id,:integer
    add_column :videos,:lesson_id,:integer
  end
end
