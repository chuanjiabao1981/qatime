class AddCustomizedCourseTypeToCustomizedCourses < ActiveRecord::Migration
  def change
    add_column :customized_courses,:customized_course_type,:integer, default: 0
  end
end
