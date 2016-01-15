class RemoveParentTypeFromTeachingProgramDirectories < ActiveRecord::Migration
  def change
    remove_column :course_library_directories, :parent_type
  end
end
