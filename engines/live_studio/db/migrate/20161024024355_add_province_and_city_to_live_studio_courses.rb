class AddProvinceAndCityToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_reference :live_studio_courses, :province, index: true
    add_reference :live_studio_courses, :city, index: true
    add_reference :live_studio_courses, :author, index: true
    change_column_null :live_studio_courses, :workstation_id, true
  end
end
