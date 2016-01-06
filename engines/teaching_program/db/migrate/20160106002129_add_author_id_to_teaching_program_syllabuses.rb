class AddAuthorIdToTeachingProgramSyllabuses < ActiveRecord::Migration
  def change
    add_column :teaching_program_syllabuses, :author_id, :integer
  end
end
