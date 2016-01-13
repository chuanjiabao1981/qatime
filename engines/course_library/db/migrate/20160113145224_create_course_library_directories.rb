class CreateCourseLibraryDirectories < ActiveRecord::Migration
  def change
    create_table :course_library_directories do |t|
      t.string :title
      t.integer :parent_id
      t.string :parent_type

      t.timestamps null: false
    end
  end
end
