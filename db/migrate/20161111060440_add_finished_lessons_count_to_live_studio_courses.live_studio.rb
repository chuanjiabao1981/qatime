# This migration comes from live_studio (originally 20161111060158)
class AddFinishedLessonsCountToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :finished_lessons_count, :integer, :default => 0
  end
end
