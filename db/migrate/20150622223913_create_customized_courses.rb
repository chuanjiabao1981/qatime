class CreateCustomizedCourses < ActiveRecord::Migration
  def change
    create_table :customized_courses do |t|
      t.integer :student_id
      t.string :category
      t.string :subject
      t.timestamps null: false
    end
  end
end
