# This migration comes from teaching_program (originally 20160106234327)
class CreateTeachingProgramSolutions < ActiveRecord::Migration
  def change
    create_table :teaching_program_solutions do |t|
      t.string :title
      t.text :description
      t.integer :homework_id

      t.timestamps null: false
    end
  end
end
