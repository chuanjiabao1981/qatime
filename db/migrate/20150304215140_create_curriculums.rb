class CreateCurriculums < ActiveRecord::Migration
  def change
    create_table :curriculums do |t|
      t.references :teacher
      t.references :teaching_program
      t.timestamps null: false
    end
  end
end
