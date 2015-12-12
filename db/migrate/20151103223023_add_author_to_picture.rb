class AddAuthorToPicture < ActiveRecord::Migration
  def change
    add_column :pictures,:author_id,:integer
  end
end
