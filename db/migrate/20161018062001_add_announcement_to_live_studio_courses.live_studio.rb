# This migration comes from live_studio (originally 20161018061739)
class AddAnnouncementToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :announcement, :string
  end
end
