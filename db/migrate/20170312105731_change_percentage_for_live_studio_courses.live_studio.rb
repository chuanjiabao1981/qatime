# This migration comes from live_studio (originally 20170312105029)
class ChangePercentageForLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :platform_percentage, :integer, default: 0
    add_column :live_studio_courses, :sell_and_platform_percentage, :integer, default: 0
    remove_column :live_studio_courses, :system_percentage
    remove_column :live_studio_courses, :sell_percentage
  end
end
