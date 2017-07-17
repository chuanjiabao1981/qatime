class AddAllCoursesCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :all_courses_count, :integer, default: 0
  end
end
