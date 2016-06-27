# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160624092232) do

  create_table "live_studio_channels", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "course_id"
    t.string   "remote_id",  limit: 100
    t.integer  "state",                  default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "live_studio_channels", ["course_id"], name: "index_live_studio_channels_on_course_id"

  create_table "live_studio_courses", force: :cascade do |t|
    t.string   "name",           limit: 100,                                       null: false
    t.integer  "teacher_id"
    t.integer  "workstation_id",                                                   null: false
    t.integer  "status",                                             default: 0
    t.text     "description"
    t.decimal  "price",                      precision: 6, scale: 2, default: 0.0
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
  end

  add_index "live_studio_courses", ["teacher_id"], name: "index_live_studio_courses_on_teacher_id"
  add_index "live_studio_courses", ["workstation_id"], name: "index_live_studio_courses_on_workstation_id"

  create_table "live_studio_lessons", force: :cascade do |t|
    t.string   "name",          limit: 100
    t.integer  "course_id"
    t.integer  "teacher_id"
    t.string   "description"
    t.integer  "state",         limit: 2,   default: 0
    t.string   "start_time",    limit: 6
    t.string   "end_time",      limit: 6
    t.date     "class_date"
    t.integer  "live_count",                default: 0
    t.datetime "live_start_at"
    t.datetime "live_end_at"
    t.integer  "real_time",                 default: 0
    t.integer  "pos",           limit: 4,   default: 0
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "live_studio_lessons", ["course_id"], name: "index_live_studio_lessons_on_course_id"
  add_index "live_studio_lessons", ["teacher_id"], name: "index_live_studio_lessons_on_teacher_id"

  create_table "live_studio_play_records", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "course_id"
    t.integer  "lesson_id"
    t.datetime "start_time_at"
    t.datetime "end_time_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "live_studio_play_records", ["course_id"], name: "index_live_studio_play_records_on_course_id"
  add_index "live_studio_play_records", ["lesson_id"], name: "index_live_studio_play_records_on_lesson_id"
  add_index "live_studio_play_records", ["student_id"], name: "index_live_studio_play_records_on_student_id"

  create_table "live_studio_streams", force: :cascade do |t|
    t.string   "protocol",   limit: 20
    t.string   "address",    limit: 255
    t.integer  "channel_id"
    t.integer  "user_count",             default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "live_studio_streams", ["channel_id"], name: "index_live_studio_streams_on_channel_id"

  create_table "live_studio_tickets", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "student_id"
    t.integer  "lesson_id"
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "live_studio_tickets", ["course_id"], name: "index_live_studio_tickets_on_course_id"
  add_index "live_studio_tickets", ["lesson_id"], name: "index_live_studio_tickets_on_lesson_id"
  add_index "live_studio_tickets", ["student_id"], name: "index_live_studio_tickets_on_student_id"

end
