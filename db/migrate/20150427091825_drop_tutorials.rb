class DropTutorials < ActiveRecord::Migration
  def change
    drop_table :tutorials
  end
end
