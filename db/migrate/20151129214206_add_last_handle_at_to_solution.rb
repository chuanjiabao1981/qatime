class AddLastHandleAtToSolution < ActiveRecord::Migration
  def change
    add_column :solutions,:last_handled_at,:timestamp
    add_column :solutions,:last_redone_at,:timestamp
  end
end
