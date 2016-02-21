class CreateCourseLibraryHomeworkPublications < ActiveRecord::Migration
  def change
    create_table :course_library_homework_publications do |t|
      t.integer :homework_id
      t.integer :course_publication_id
      t.timestamps null: false
    end
  end
end
