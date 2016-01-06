# This migration comes from teaching_program (originally 20160106233757)
class CreateTeachingProgramHomeworks < ActiveRecord::Migration
  def change
    create_table :teaching_program_homeworks do |t|
      t.string :title
      t.text :description
      t.integer :course_id

      t.timestamps null: false
    end
  end
end
