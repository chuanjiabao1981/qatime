class RemoveNoUseColFromGroups < ActiveRecord::Migration
  def change
    remove_column :groups,:city_name,:string
    remove_column :groups,:teacher_name,:string
    remove_column :groups,:school_name,:string
  end
end
