class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string  :name
      t.text    :desc
      t.integer :node_id
      t.integer :section_id
      t.integer :author_id
      t.integer :course_id
      t.string  :token
      t.timestamps
    end
  end
end
