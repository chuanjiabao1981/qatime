# This migration comes from course_library (originally 20160113145524)
class CreateCourseLibrarySolutions < ActiveRecord::Migration
  def change
    create_table :course_library_solutions do |t|
      t.string :title
      t.text :description
      t.integer :homework_id

      t.timestamps null: false
    end
  end
end
