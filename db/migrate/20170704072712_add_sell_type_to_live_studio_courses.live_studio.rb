# This migration comes from live_studio (originally 20170704071833)
class AddSellTypeToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :sell_type, :integer, limit: 2, default: 1
  end
end
