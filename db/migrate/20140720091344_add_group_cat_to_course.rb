class AddGroupCatToCourse < ActiveRecord::Migration
  def change
    add_column :courses,:group_type_id,:integer
    add_column :courses,:group_catalogue_id,:integer
  end
end
