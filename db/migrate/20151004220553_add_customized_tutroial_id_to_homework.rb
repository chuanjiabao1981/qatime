class AddCustomizedTutroialIdToHomework < ActiveRecord::Migration
  def change
    add_column :examinations,:customized_tutorial_id,:integer
    add_column :examinations,:comments_count,:integer,default: 0
    add_column :customized_courses,:exercises_count,:integer,default: 0
  end
end
