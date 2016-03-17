class AddDescToCustomizedCourse < ActiveRecord::Migration
  def change
    add_column :customized_courses,:desc,:text
  end
end
