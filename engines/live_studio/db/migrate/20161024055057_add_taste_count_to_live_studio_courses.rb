class AddTasteCountToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :taste_count, :integer, default: 0
  end
end
