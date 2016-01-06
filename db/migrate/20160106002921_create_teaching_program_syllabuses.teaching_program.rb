# This migration comes from teaching_program (originally 20160106002023)
class CreateTeachingProgramSyllabuses < ActiveRecord::Migration
  def change
    create_table :teaching_program_syllabuses do |t|
      t.string :title
      t.text :description

      t.timestamps null: false
    end
  end
end
