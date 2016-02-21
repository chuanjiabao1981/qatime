class AddPublicationToExercise < ActiveRecord::Migration
  def change
    add_column :examinations,:homework_publication_id,:integer

  end
end
