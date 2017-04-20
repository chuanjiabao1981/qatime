# This migration comes from live_studio (originally 20170317023646)
class AddStartAtAndEndAtToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :start_at, :datetime, index: true
    add_column :live_studio_courses, :end_at, :datetime, index: true
  end
end
