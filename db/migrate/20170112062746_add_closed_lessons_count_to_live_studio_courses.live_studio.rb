# This migration comes from live_studio (originally 20170112062636)
class AddClosedLessonsCountToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :closed_lessons_count, :integer, default: 0
  end
end
