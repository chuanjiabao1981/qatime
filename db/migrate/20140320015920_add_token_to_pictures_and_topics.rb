class AddTokenToPicturesAndTopics < ActiveRecord::Migration
  def change
    add_column :topics,:token,:string
    add_column :pictures,:token,:string
  end
end
