# This migration comes from live_studio (originally 20161024024355)
class AddProvinceAndCityToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_reference :live_studio_courses, :province, index: true
    add_reference :live_studio_courses, :city, index: true
    add_reference :live_studio_courses, :author, polymorphic: true, index: true
    change_column_null :live_studio_courses, :workstation_id, true
  end
end
