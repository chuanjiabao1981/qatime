class CreateTeachingProgramSyllabuses < ActiveRecord::Migration
  def change
    create_table :teaching_program_syllabuses do |t|
      t.string :title
      t.text :description

      t.timestamps null: false
    end
  end
end
