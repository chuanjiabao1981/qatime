class RefactoryHomeworkTable < ActiveRecord::Migration
  def change
    rename_table :homeworks,:examinations
    add_column :examinations,:type,:string
  end
end
