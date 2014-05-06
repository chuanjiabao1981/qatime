class AddGradeToGroup < ActiveRecord::Migration
  def change
    add_column :groups,:grade,:string
    add_index :groups,:grade
  end
end
