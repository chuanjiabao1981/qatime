# This migration comes from live_studio (originally 20160620104749)
class CreateLiveStudioLessons < ActiveRecord::Migration
  def change
    create_table :live_studio_lessons do |t|
      t.string :name, limit: 100
      t.references :course, index: true
      t.references :teacher, index: true
      t.string :description
      t.integer :state, limit: 2, default: 0
      t.string :start_time, limit: 6
      t.string :end_time, limit: 6
      t.date :class_date
      t.integer :live_count, default: 0
      t.datetime :live_start_at
      t.datetime :live_end_at
      t.integer :real_time, default: 0
      t.integer :pos, limit: 4, default: 0

      t.timestamps null: false
    end
  end
end
