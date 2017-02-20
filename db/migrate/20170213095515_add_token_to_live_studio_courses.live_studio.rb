# This migration comes from live_studio (originally 20170213095406)
class AddTokenToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :token, :string
  end
end
