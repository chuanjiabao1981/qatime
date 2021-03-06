# This migration comes from live_studio (originally 20160804022512)
class AddClassDateToCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :class_date, :date

    LiveStudio::Course.find_each(:batch_size => 500 ) do |course|
      first_class_date = course.lessons.order(:class_date).first.try(:class_date)
      course.update(class_date: first_class_date) if first_class_date.present?
    end
  end
end
