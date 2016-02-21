class RenmaeCourseIdOfCustomizedTutorial < ActiveRecord::Migration
  def change
    rename_column :customized_tutorials,:course_id,:template_id
  end
end
