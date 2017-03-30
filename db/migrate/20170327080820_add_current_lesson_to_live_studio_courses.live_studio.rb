# This migration comes from live_studio (originally 20170323022737)
class AddCurrentLessonToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_reference :live_studio_courses, :current_lesson
  end
end
