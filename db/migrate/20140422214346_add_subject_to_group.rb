class AddSubjectToGroup < ActiveRecord::Migration
  def change
    add_column :groups,:subject,:string
    add_index :groups,:subject
    add_index :groups,[:subject,:grade]
  end
end
