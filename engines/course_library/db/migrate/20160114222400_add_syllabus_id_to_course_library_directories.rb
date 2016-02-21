class AddSyllabusIdToCourseLibraryDirectories < ActiveRecord::Migration
  def change
    add_column :course_library_directories, :syllabus_id, :integer
  end
end
