class CreateCourseLibraryCoursePublications < ActiveRecord::Migration
  def change
    create_table :course_library_course_publications do |t|
      t.boolean :publish_lecture_switch,default: false
      t.integer :customized_course_id
      t.integer :course_id
      t.timestamps null: false
    end
  end
end
