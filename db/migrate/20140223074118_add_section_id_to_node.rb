class AddSectionIdToNode < ActiveRecord::Migration
  def change
    add_column :nodes,:section_id,:integer
  end
end
