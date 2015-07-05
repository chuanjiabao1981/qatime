class CreateCustomizedCourses < ActiveRecord::Migration
  def change
    create_table :customized_courses do |t|
      t.integer :student_id
      t.string :category,:default=> "高中"
      t.string :subject,:default=> "数学"
      t.timestamps null: false
    end
  end
end
