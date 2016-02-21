class CreateCustomizedCourses < ActiveRecord::Migration
  def change
    create_table :customized_courses do |t|

      t.timestamps null: false
    end
  end
end
