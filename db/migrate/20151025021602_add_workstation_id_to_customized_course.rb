class AddWorkstationIdToCustomizedCourse < ActiveRecord::Migration
  def change
    add_column :customized_courses,:workstation_id,:integer
  end
end