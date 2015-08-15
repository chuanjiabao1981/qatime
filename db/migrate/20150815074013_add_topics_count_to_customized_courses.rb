class AddTopicsCountToCustomizedCourses < ActiveRecord::Migration
  def change
    add_column :customized_courses,:topics_count,:integer,default:0

  end
end
