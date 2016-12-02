# This migration comes from live_studio (originally 20161201100344)
class AddStartedLessonsCountToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :started_lessons_count, :integer, default: 0
    rename_column :live_studio_courses, :completed_lesson_count, :completed_lessons_count
  end
end
