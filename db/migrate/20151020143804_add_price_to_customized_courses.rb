class AddPriceToCustomizedCourses < ActiveRecord::Migration
  def change
    add_column :customized_courses,:price,:integer
  end
end