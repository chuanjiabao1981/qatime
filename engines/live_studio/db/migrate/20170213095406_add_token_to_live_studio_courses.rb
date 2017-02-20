class AddTokenToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :token, :string
  end
end
