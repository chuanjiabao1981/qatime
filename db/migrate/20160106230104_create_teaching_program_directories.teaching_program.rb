# This migration comes from teaching_program (originally 20160106225515)
class CreateTeachingProgramDirectories < ActiveRecord::Migration
  def change
    create_table :teaching_program_directories do |t|
      t.string :title
      t.integer :syllabus_id
      t.integer :parent_id

      t.timestamps null: false
    end
  end
end
