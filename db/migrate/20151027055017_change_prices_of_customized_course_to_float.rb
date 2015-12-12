class ChangePricesOfCustomizedCourseToFloat < ActiveRecord::Migration
  def change
    change_column :customized_courses, :teacher_price, :float
    change_column :customized_courses, :platform_price, :float
    change_column :corrections, :teacher_price, :float
    change_column :corrections, :platform_price, :float
    change_column :replies, :teacher_price, :float
    change_column :replies, :platform_price, :float
    change_column :customized_tutorials, :teacher_price, :float
    change_column :customized_tutorials, :platform_price, :float
    change_column :fees, :teacher_price, :float
    change_column :fees, :platform_price, :float
  end
end
