# This migration comes from teaching_program (originally 20160106233016)
class CreateTeachingProgramCourses < ActiveRecord::Migration
  def change
    create_table :teaching_program_courses do |t|
      t.string :title
      t.text :description
      t.integer :directory_id

      t.timestamps null: false
    end
  end
end
