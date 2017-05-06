class AddLeftPriceToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :left_price, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
