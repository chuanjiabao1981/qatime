# This migration comes from live_studio (originally 20170114130117)
class AddAdjustBuyCountToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :adjust_buy_count, :integer, default: 0
  end
end
