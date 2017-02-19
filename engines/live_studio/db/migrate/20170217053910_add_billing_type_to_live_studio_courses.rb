class AddBillingTypeToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :billing_type, :string
  end
end
