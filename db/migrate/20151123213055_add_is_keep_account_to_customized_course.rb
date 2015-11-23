class AddIsKeepAccountToCustomizedCourse < ActiveRecord::Migration
  def change
    add_column :customized_courses,:is_keep_account,:boolean,default: false
  end
end
