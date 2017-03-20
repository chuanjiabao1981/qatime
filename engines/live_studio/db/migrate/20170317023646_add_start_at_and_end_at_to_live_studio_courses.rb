class AddStartAtAndEndAtToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :start_at, :datetime, index: true
    add_column :live_studio_courses, :end_at, :datetime, index: true
  end
end
