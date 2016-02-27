class AddPositionToCourseLibraryDirectories < ActiveRecord::Migration
  def change
    add_column :course_library_directories, :position, :integer
  end
end
