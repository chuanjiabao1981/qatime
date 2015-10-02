class AddCorrectionInfoToSolution < ActiveRecord::Migration
  def change
    add_column :solutions,:first_correction_created_at,:timestamp
    add_column :solutions,:last_correction_created_at,:timestamp
    add_column :solutions,:first_correction_author_id,:integer
    add_column :solutions,:last_correction_author_id,:integer
  end
end
