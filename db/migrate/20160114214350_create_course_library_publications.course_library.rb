# This migration comes from course_library (originally 20160113221627)
class CreateCourseLibraryPublications < ActiveRecord::Migration
  def change
    create_table :course_library_publications do |t|
      t.references :course
      t.references :courseable,polymorphic: true
      t.timestamps null: false
    end
  end
end
