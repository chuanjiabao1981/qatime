# This migration comes from live_studio (originally 20161111055122)
class AddLessonsCountToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :lessons_count, :integer, :default => 0
  end
end
