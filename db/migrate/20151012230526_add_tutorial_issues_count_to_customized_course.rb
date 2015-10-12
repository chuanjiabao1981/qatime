class AddTutorialIssuesCountToCustomizedCourse < ActiveRecord::Migration
  def change
    add_column :customized_courses,:course_issues,:integer,default:0
  end
end
