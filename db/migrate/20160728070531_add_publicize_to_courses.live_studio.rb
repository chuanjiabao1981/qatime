# This migration comes from live_studio (originally 20160728063526)
class AddPublicizeToCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :publicize, :string
  end
end
