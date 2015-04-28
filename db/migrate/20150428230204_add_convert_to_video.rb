class AddConvertToVideo < ActiveRecord::Migration
  def change
    add_column :videos,:convert_name,:string
    remove_column :videos,:tutorial_id
  end
end
