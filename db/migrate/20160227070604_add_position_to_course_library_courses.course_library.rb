# This migration comes from course_library (originally 20160227065429)
class AddPositionToCourseLibraryCourses < ActiveRecord::Migration
  def change
    add_column :course_library_courses, :position, :integer
  end
end
