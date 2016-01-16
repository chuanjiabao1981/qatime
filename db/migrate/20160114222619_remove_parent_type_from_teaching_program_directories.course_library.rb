# This migration comes from course_library (originally 20160114222155)
class RemoveParentTypeFromTeachingProgramDirectories < ActiveRecord::Migration
  def change
    remove_column :course_library_directories, :parent_type
  end
end
