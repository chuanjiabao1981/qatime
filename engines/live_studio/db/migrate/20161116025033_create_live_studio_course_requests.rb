class CreateLiveStudioCourseRequests < ActiveRecord::Migration
  def change
    create_table :live_studio_course_requests do |t|
      t.references :user, index: true
      t.references :course, index: true
      t.references :workstation, index: true
      t.integer :status
      t.datetime :handled_at

      t.timestamps null: false
    end
  end
end
