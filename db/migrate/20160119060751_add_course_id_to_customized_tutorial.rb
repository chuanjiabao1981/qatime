class AddCourseIdToCustomizedTutorial < ActiveRecord::Migration
  def change
    add_column :customized_tutorials,:course_id,:integer
  end
end
