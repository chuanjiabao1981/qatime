class CreateCourseLibraryHomeworks < ActiveRecord::Migration
  def change
    create_table :course_library_homeworks do |t|
      t.string :title
      t.text :description
      t.integer :course_id

      t.timestamps null: false
    end
  end
end
