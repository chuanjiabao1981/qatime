# This migration comes from live_studio (originally 20170217053910)
class AddBillingTypeToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :billing_type, :string
  end
end
