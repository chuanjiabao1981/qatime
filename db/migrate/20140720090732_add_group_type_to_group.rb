class AddGroupTypeToGroup < ActiveRecord::Migration
  def change
    add_column :groups,:group_type_id,:integer
  end
end
