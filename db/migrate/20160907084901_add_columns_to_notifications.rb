class AddColumnsToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :live_studio_course_id, :integer
    add_column :notifications, :live_studio_lesson_id, :integer
  end
end
