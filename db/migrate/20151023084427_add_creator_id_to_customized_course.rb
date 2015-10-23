class AddCreatorIdToCustomizedCourse < ActiveRecord::Migration
  def change
    add_column :customized_courses,:creator_id,:integer
  end
end
