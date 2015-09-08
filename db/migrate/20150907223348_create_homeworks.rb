class CreateHomeworks < ActiveRecord::Migration
  def change
    create_table :homeworks do |t|
      t.integer :customized_course_id
      t.integer :teacher_id
      t.string  :title
      t.text    :content
      t.string  :token
      t.integer :topics_count,default: 0
      t.timestamps null: false
    end
    add_column :customized_courses, :homeworks_count,:integer,:default=>0
  end
end
