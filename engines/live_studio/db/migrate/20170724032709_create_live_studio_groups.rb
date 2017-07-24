class CreateLiveStudioGroups < ActiveRecord::Migration
  def change
    create_table :live_studio_groups do |t|
      t.string :name, limit: 100, null: false
      t.string :type
      t.references :teacher, index: true
      t.references :workstation, index: true
      t.integer :status, default: 0
      t.text :description
      t.decimal :price, precision: 8, scale: 2, default: 0.0
      t.decimal :lesson_price, precision: 8, scale: 2, default: 0.0 # 课程单价
      t.integer :teacher_percentage, limit: 4, default: 0 # 教师分成
      t.integer :lesson_count, limit: 4, default: 0 # 课程数量
      t.integer :preset_lesson_count, limit: 4, default: 0 # 预设课程数量
      t.integer :completed_lesson_count, limit: 4, default: 0 # 完成课程数量
      t.datetime :deleted_at
      t.timestamps null: false

      t.string   "subject"
      t.string   "grade"
      t.string   "publicize"
      t.integer  "buy_tickets_count",                                                 default: 0
      t.date     "class_date"
      t.datetime "published_at"
      t.string   "announcement"
      t.references :province, index: true
      t.references :city, index: true
      t.references :author, index: true
      t.integer  "taste_count",                                                       default: 0
      t.integer  "lessons_count",                                                     default: 0
      t.integer  "finished_lessons_count",                                            default: 0
      t.integer  "started_lessons_count",                                             default: 0
      t.integer  "adjust_buy_count",                                                  default: 0
      t.integer  "closed_lessons_count",                                              default: 0
      t.string   "token"
      t.string   "billing_type"
      t.integer  "publish_percentage",                                                default: 0
      t.decimal  "base_price",                               precision: 4,  scale: 2, default: 0.1
      t.integer  "platform_percentage",                                               default: 0
      t.integer  "sell_and_platform_percentage",                                      default: 0
      t.datetime "start_at"
      t.datetime "end_at"
      t.decimal  "left_price",                               precision: 10, scale: 2, default: 0.0
      t.string   "objective"
      t.string   "suit_crowd"
      t.integer  "current_lesson_id"
      t.integer  "sell_type",                    limit: 2,                            default: 1
    end

    add_index :live_studio_groups, :class_date
    add_index :live_studio_groups, :preset_lesson_count
    add_index :live_studio_groups, :price
    add_index :live_studio_groups, :published_at
  end
end
