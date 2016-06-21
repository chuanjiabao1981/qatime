# This migration comes from live_studio (originally 20160620104749)
class CreateLiveStudioLessons < ActiveRecord::Migration
  def change
    create_table :live_studio_lessons do |t|
      t.string :name
      t.references :course, index: true
      t.string :description
      t.integer :state
      t.string :start_time
      t.string :end_time
      t.date :class_date

      t.timestamps null: false
    end
  end
end
