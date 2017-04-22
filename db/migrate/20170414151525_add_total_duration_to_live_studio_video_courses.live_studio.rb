# This migration comes from live_studio (originally 20170414151414)
class AddTotalDurationToLiveStudioVideoCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_video_courses, :total_duration, :integer, default: 0
  end
end
