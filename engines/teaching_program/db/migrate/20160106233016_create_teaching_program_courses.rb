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
