class TeacherAddColumnPass < ActiveRecord::Migration
  def change
    add_column :users,:pass,:boolean,:default => false
  end
end
