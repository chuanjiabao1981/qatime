class AddColumnsToCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :subject, :string
    add_column :live_studio_courses, :grade, :string
  end
end
