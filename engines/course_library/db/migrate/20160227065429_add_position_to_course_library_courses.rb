class AddPositionToCourseLibraryCourses < ActiveRecord::Migration
  def change
    add_column :course_library_courses, :position, :integer
  end
end
