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

ActiveRecord::Schema.define(version: 20140521231449) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cities", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "body"
    t.integer  "author_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: true do |t|
    t.string   "name"
    t.text     "desc"
    t.integer  "lessons_count", default: 0
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "price",         default: 0.0
    t.integer  "group_id"
    t.integer  "teacher_id"
    t.string   "state",         default: "unpublished"
  end

  create_table "covers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tutorial_id"
    t.string   "token"
    t.integer  "course_id"
  end

  add_index "covers", ["token"], name: "index_covers_on_token", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.integer  "city_id"
    t.integer  "school_id"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "grade"
    t.string   "subject"
    t.integer  "courses_count", default: 0
  end

  add_index "groups", ["grade"], name: "index_groups_on_grade", using: :btree
  add_index "groups", ["subject", "grade"], name: "index_groups_on_subject_and_grade", using: :btree
  add_index "groups", ["subject"], name: "index_groups_on_subject", using: :btree

  create_table "lessons", force: true do |t|
    t.string   "name"
    t.text     "desc"
    t.integer  "course_id"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.integer  "teacher_id"
  end

  create_table "nodes", force: true do |t|
    t.string   "name"
    t.string   "summary"
    t.integer  "topics_count",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "section_id"
    t.integer  "tutorials_count", default: 0
    t.integer  "courses_count",   default: 0
    t.string   "en_name"
  end

  add_index "nodes", ["name"], name: "index_nodes_on_name", using: :btree

  create_table "pictures", force: true do |t|
    t.string   "name"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

  create_table "recharge_codes", force: true do |t|
    t.integer  "money",      default: 500
    t.string   "code"
    t.integer  "admin_id"
    t.string   "desc"
    t.boolean  "is_used",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "replies", force: true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", force: true do |t|
    t.string   "name"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "replies_count", default: 0
    t.integer  "node_id"
    t.string   "node_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.integer  "section_id"
    t.integer  "course_id"
    t.integer  "group_id"
    t.integer  "author_id"
  end

  create_table "tutorials", force: true do |t|
    t.string   "title"
    t.text     "summary"
    t.text     "content"
    t.integer  "author_id"
    t.integer  "uploader_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.integer  "node_id"
    t.integer  "comments_count", default: 0
    t.integer  "section_id"
  end

  add_index "tutorials", ["token"], name: "index_tutorials_on_token", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "topics_count",           default: 0
    t.integer  "replies_count",          default: 0
    t.string   "name"
    t.string   "avatar"
    t.integer  "school_id"
    t.string   "role"
    t.string   "password_digest"
    t.string   "remember_token"
    t.text     "desc"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "videos", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tutorial_id"
    t.string   "token"
    t.integer  "lesson_id"
  end

  add_index "videos", ["token"], name: "index_videos_on_token", using: :btree

end
