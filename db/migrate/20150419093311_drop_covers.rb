class DropCovers < ActiveRecord::Migration
  def change
    drop_table :covers
  end
end
