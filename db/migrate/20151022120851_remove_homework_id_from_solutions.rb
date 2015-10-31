class RemoveHomeworkIdFromSolutions < ActiveRecord::Migration
  def change
    remove_column :solutions,:homework_id,:integer
  end
end
