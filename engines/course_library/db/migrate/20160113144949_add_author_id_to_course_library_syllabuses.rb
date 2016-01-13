class AddAuthorIdToCourseLibrarySyllabuses < ActiveRecord::Migration
  def change
    add_column :course_library_syllabuses, :author_id, :integer
  end
end
