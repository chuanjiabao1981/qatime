class CreateTutorialIssues < ActiveRecord::Migration
  def change
    create_table :tutorial_issues do |t|
      t.integer :customized_course_id
      t.integer :customized_tutorial_id
      t.integer :student_id
      t.integer :teacher_id
      t.integer :topics_count
      t.timestamps null: false
    end
    add_column :customized_tutorials,:tutorial_issues_count,:integer,default: 0
    add_column :customized_courses,:tutorial_issues_count,:integer,default: 0
  end
end
