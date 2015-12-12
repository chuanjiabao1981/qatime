class AddCustomizedCourseIdToNotification < ActiveRecord::Migration
  def change
    add_column :notifications,:customized_course_id,:integer

  end
end
