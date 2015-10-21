class AddTeacherPriceToCustomizedCourse < ActiveRecord::Migration
  def change
    add_column :customized_courses,:teacher_price,:integer
  end
end
