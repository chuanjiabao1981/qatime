class AddClassDateToCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :class_date, :date

    LiveStudio::Course.find_each(:batch_size => 500 ) do |course|
      first_class_date = course.lessons.order(:class_date).first.class_date
      course.update(class_date: first_class_date)
    end
  end
end
