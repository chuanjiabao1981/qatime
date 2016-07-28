class AddPublicizeToCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :publicize, :string
  end
end
