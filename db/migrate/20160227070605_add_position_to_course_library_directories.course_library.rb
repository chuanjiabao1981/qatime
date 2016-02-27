# This migration comes from course_library (originally 20160227065450)
class AddPositionToCourseLibraryDirectories < ActiveRecord::Migration
  def change
    add_column :course_library_directories, :position, :integer
  end
end
