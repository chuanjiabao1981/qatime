class AddNameIndexToNode < ActiveRecord::Migration
  def change
    add_index :nodes,:name
  end
end
