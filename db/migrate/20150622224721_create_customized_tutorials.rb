class CreateCustomizedTutorials < ActiveRecord::Migration
  def change
    create_table :customized_tutorials do |t|
      t.integer :teacher_id
      t.integer :customized_course_id
      t.string  :title
      t.text    :content
      t.integer :position,:default => 0
      t.timestamps null: false
    end
  end
end
