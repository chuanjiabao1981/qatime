class CreateCourseIntros < ActiveRecord::Migration
  def change
    create_table :course_intros do |t|
      t.references :video, index: true
      t.string :title
      t.integer :status, default: 0
      t.timestamps null: false
    end
  end
end
