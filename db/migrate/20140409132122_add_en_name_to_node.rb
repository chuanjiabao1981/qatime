class AddEnNameToNode < ActiveRecord::Migration
  def change
    add_column :nodes,:en_name,:string
  end
end
