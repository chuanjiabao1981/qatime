# This migration comes from live_studio (originally 20170321124100)
class AddObjectiveToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :objective, :string # 课程目标
    add_column :live_studio_courses, :suit_crowd, :string # 适合人群
  end
end
