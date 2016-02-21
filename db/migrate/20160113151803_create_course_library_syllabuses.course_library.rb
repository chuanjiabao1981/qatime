# This migration comes from course_library (originally 20160113144659)
class CreateCourseLibrarySyllabuses < ActiveRecord::Migration
  def change
    create_table :course_library_syllabuses do |t|
      t.string :title
      t.text :description

      t.timestamps null: false
    end
  end
end
