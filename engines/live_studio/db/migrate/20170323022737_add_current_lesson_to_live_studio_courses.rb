class AddCurrentLessonToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_reference :live_studio_courses, :current_lesson
  end
end
