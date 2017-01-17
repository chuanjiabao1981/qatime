class AddAdjustBuyCountToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :adjust_buy_count, :integer, default: 0
  end
end
