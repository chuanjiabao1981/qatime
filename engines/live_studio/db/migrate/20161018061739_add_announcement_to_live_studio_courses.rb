class AddAnnouncementToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :announcement, :string
  end
end
