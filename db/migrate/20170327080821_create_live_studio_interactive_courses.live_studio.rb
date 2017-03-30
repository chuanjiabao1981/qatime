# This migration comes from live_studio (originally 20170327064053)
class CreateLiveStudioInteractiveCourses < ActiveRecord::Migration
  def change
    create_table :live_studio_interactive_courses do |t|
      t.string   "name",                         limit: 100,                                        null: false
      t.integer  "workstation_id"
      t.integer  "author_id"
      t.integer  "status",                                                            default: 0
      t.text     "description"
      t.string   "subject"
      t.string   "grade"
      t.string   "objective"
      t.string   "suit_crowd"
      t.string   "publicize"
      t.decimal  "price",                                    precision: 8,  scale: 2, default: 0.0
      t.decimal  "service_price",                            precision: 10, scale: 2, default: 0.0
      t.decimal  "lesson_price",                             precision: 8,  scale: 2, default: 0.0
      t.integer  "teacher_percentage",                                                default: 0
      t.integer  "lesson_count",                                                      default: 0
      t.integer  "interactive_lessons_count",                                         default: 0
      t.integer  "preset_lesson_count",                                               default: 0
      t.integer  "completed_lessons_count",                                           default: 0
      t.datetime "deleted_at"
      t.timestamps null: false
      t.integer  "buy_tickets_count",                                                 default: 0
      t.date     "class_date"
      t.datetime "published_at"
      t.string   "announcement"
      t.integer  "province_id"
      t.integer  "city_id"
      t.integer  "taste_count",                                                       default: 0
      t.integer  "finished_lessons_count",                                            default: 0
      t.integer  "started_lessons_count",                                             default: 0
      t.integer  "closed_lessons_count",                                              default: 0
      t.integer  "adjust_buy_count",                                                  default: 0
      t.string   "token"
      t.string   "billing_type"
      t.integer  "publish_percentage",                                                default: 0
      t.decimal  "base_price",                               precision: 4,  scale: 2, default: 0.1
      t.integer  "platform_percentage",                                               default: 0
      t.integer  "sell_and_platform_percentage",                                      default: 0
      t.datetime "start_at"
      t.datetime "end_at"
      t.decimal  "left_price",                               precision: 10, scale: 2, default: 0.0
    end

    add_index :live_studio_interactive_courses, :author_id
    add_index :live_studio_interactive_courses, :workstation_id
    add_index :live_studio_interactive_courses, :status
    add_index :live_studio_interactive_courses, :province_id
    add_index :live_studio_interactive_courses, :city_id
    add_index :live_studio_interactive_courses, :class_date
    add_index :live_studio_interactive_courses, :preset_lesson_count
    add_index :live_studio_interactive_courses, :price
    add_index :live_studio_interactive_courses, :published_at

    create_table :live_studio_interactive_lessons do |t|
      t.string   "name",           limit: 100
      t.integer  "interactive_course_id"
      t.integer  "teacher_id"
      t.string   "subject"
      t.string   "description"
      t.integer  "status",         limit: 2,   default: 0
      t.string   "start_time",     limit: 6
      t.string   "end_time",       limit: 6
      t.date     "class_date"
      t.integer  "live_count",                 default: 0
      t.datetime "live_start_at"
      t.datetime "live_end_at"
      t.integer  "real_time",                  default: 0
      t.integer  "pos",                        default: 0
      t.datetime "deleted_at"
      t.timestamps null: false
      t.datetime "heartbeat_time"
      t.integer  "duration"
      t.integer  "replay_status",              default: 0
    end

    add_index :live_studio_interactive_lessons, :interactive_course_id
    add_index :live_studio_interactive_lessons, :teacher_id
    add_index :live_studio_interactive_lessons, :status

  end
end
