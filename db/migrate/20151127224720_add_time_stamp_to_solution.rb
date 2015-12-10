class AddTimeStampToSolution < ActiveRecord::Migration
  def change
    add_column :solutions,:first_handled_at,:timestamp
    add_column :solutions,:completed_at,:timestamp
  end
end
