class AddIndexToCourses < ActiveRecord::Migration
  def change
    add_index :live_studio_courses, :published_at
    add_index :live_studio_courses, :price
    add_index :live_studio_courses, :preset_lesson_count
    add_index :live_studio_courses, :class_date
  end
end
