class AddLessonsCountToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :lessons_count, :integer, :default => 0
  end
end
