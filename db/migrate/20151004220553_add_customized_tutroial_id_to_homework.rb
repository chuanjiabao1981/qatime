class AddCustomizedTutroialIdToHomework < ActiveRecord::Migration
  def change
    add_column :homeworks,:customized_tutorial_id,:integer
    add_column :homeworks,:comments_count,:integer,default: 0
    add_column :customized_courses,:exercises_count,:integer,default: 0
  end
end
