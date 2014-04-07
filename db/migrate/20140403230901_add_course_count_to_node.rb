class AddCourseCountToNode < ActiveRecord::Migration
  def change
    add_column :nodes,:courses_count,:integer,:default => 0
  end
end
