class AddCustomizedCourseIdToComent < ActiveRecord::Migration
  def change
    add_column :comments,:customized_course_id,:integer
  end
end
