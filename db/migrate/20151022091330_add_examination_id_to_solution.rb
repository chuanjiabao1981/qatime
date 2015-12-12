class AddExaminationIdToSolution < ActiveRecord::Migration
  def change
    add_column :solutions,:examination_id,:integer
  end
end
