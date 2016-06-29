# This migration comes from live_studio (originally 20160615055512)
class CreateLiveStudioCourses < ActiveRecord::Migration
  def change
    create_table :live_studio_courses do |t|
      t.string :name, limit: 100, null: false
      t.references :teacher, index: true
      t.references :workstation, index: true, null: false
      t.integer :status, default: 0
      t.text :description
      t.decimal :price, precision: 6, scale: 2, default: 0.0
      t.decimal :lesson_price, precision: 6, scale: 2, default: 0.0 # 课程单价
      t.integer :teacher_percentage, limit: 4, default: 0 # 教师分成
      t.integer :lesson_count, limit: 4, default: 0 # 课程数量
      t.integer :preset_lesson_count, limit: 4, default: 0 # 预设课程数量
      t.integer :completed_lesson_count, limit: 4, default: 0 # 完成课程数量

      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
