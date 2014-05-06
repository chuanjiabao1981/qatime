class AddCourseCountToGroup < ActiveRecord::Migration
  def change
    add_column :groups,:courses_count,:integer,:default => 0
  end
end
