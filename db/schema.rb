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

ActiveRecord::Schema.define(version: 20150403230006) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "money",        default: 0
    t.integer  "lock_version", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "teacher_id"
    t.string   "token"
    t.text     "content"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "author_id"
    t.integer  "commentable_id"
    t.string   "commentable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_purchase_records", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_purchase_records", ["course_id"], name: "index_course_purchase_records_on_course_id", using: :btree
  add_index "course_purchase_records", ["student_id", "course_id"], name: "student_id_course_id", unique: true, using: :btree
  add_index "course_purchase_records", ["student_id"], name: "index_course_purchase_records_on_student_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "name",                          limit: 255
    t.text     "desc"
    t.integer  "lessons_count",                             default: 0
    t.string   "token",                         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "price",                                     default: 30.0
    t.integer  "group_id"
    t.integer  "teacher_id"
    t.string   "state",                         limit: 255, default: "unpublished"
    t.integer  "course_purchase_records_count"
    t.integer  "group_type_id"
    t.integer  "group_catalogue_id"
    t.integer  "curriculum_id"
    t.string   "chapter"
    t.integer  "position",                                  default: 0
  end

  create_table "covers", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tutorial_id"
    t.string   "token",       limit: 255
    t.integer  "course_id"
  end

  add_index "covers", ["token"], name: "index_covers_on_token", using: :btree

  create_table "curriculums", force: :cascade do |t|
    t.integer  "teacher_id"
    t.integer  "teaching_program_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "courses_count",       default: 0
    t.integer  "lessons_count",       default: 0
  end

  create_table "faq_topics", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "user_type",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "faqs", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.text     "desc"
    t.string   "token",        limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "faq_type",     limit: 255
    t.integer  "faq_topic_id"
    t.integer  "is_top",                   default: 0
    t.string   "video_url",    limit: 255
  end

  add_index "faqs", ["user_id"], name: "index_faqs_on_user_id", using: :btree

  create_table "group_catalogues", force: :cascade do |t|
    t.integer  "group_type_id"
    t.string   "name",          limit: 255
    t.integer  "index"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "grade",      limit: 255
    t.string   "subject",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",                  limit: 255
    t.integer  "city_id"
    t.integer  "school_id"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "grade",                 limit: 255
    t.string   "subject",               limit: 255
    t.integer  "courses_count",                     default: 0
    t.integer  "joined_students_count",             default: 0
    t.integer  "group_type_id"
  end

  add_index "groups", ["grade"], name: "index_groups_on_grade", using: :btree
  add_index "groups", ["subject", "grade"], name: "index_groups_on_subject_and_grade", using: :btree
  add_index "groups", ["subject"], name: "index_groups_on_subject", using: :btree

  create_table "learning_plan_assignments", force: :cascade do |t|
    t.integer  "learning_plan_id"
    t.integer  "teacher_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "learning_plans", force: :cascade do |t|
    t.string   "duration_type"
    t.string   "state"
    t.integer  "student_id"
    t.integer  "vip_class_id"
    t.float    "price"
    t.datetime "begin_at"
    t.datetime "end_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "lessons", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.text     "desc"
    t.integer  "course_id"
    t.string   "token",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.integer  "teacher_id"
    t.integer  "curriculum_id"
    t.string   "state",                     default: "init"
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "message_type", limit: 255
    t.string   "status",       limit: 255
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nodes", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "summary",         limit: 255
    t.integer  "topics_count",                default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "section_id"
    t.integer  "tutorials_count",             default: 0
    t.integer  "courses_count",               default: 0
    t.string   "en_name",         limit: 255
  end

  add_index "nodes", ["name"], name: "index_nodes_on_name", using: :btree

  create_table "pictures", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.integer  "imageable_id"
    t.string   "imageable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token",          limit: 255
  end

  create_table "questions", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.string   "token"
    t.integer  "student_id"
    t.integer  "answers_count",    default: 0
    t.integer  "vip_class_id"
    t.integer  "learning_plan_id"
    t.jsonb    "infos",            default: {}, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "questions", ["infos"], name: "index_questions_on_infos", using: :gin

  create_table "recharge_codes", force: :cascade do |t|
    t.integer  "money",                    default: 500
    t.string   "code",         limit: 255
    t.integer  "admin_id"
    t.string   "desc",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_id"
    t.integer  "lock_version",             default: 0
  end

  add_index "recharge_codes", ["code"], name: "index_recharge_codes_on_code", using: :btree

  create_table "recharge_records", force: :cascade do |t|
    t.integer  "student_id"
    t.string   "code",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recharge_code_id"
  end

  create_table "register_codes", force: :cascade do |t|
    t.string   "value",                            null: false
    t.string   "state",      default: "available"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "user_id"
  end

  create_table "replies", force: :cascade do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token",      limit: 255
  end

  create_table "review_records", force: :cascade do |t|
    t.integer  "lesson_id"
    t.integer  "manager_id"
    t.string   "complete_state"
    t.string   "start_state"
    t.text     "reason"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "schools", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_join_group_records", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "student_join_group_records", ["group_id"], name: "index_student_join_group_records_on_group_id", using: :btree
  add_index "student_join_group_records", ["student_id", "group_id"], name: "index_student_join_group_records_on_student_id_and_group_id", unique: true, using: :btree
  add_index "student_join_group_records", ["student_id"], name: "index_student_join_group_records_on_student_id", using: :btree

  create_table "teaching_programs", force: :cascade do |t|
    t.string   "name"
    t.string   "category"
    t.string   "grade"
    t.string   "subject"
    t.jsonb    "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topics", force: :cascade do |t|
    t.string   "title",         limit: 255
    t.text     "body"
    t.integer  "replies_count",             default: 0
    t.integer  "node_id"
    t.string   "node_name",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token",         limit: 255
    t.integer  "section_id"
    t.integer  "course_id"
    t.integer  "group_id"
    t.integer  "author_id"
    t.integer  "curriculum_id"
  end

  create_table "tutorials", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.text     "summary"
    t.text     "content"
    t.integer  "author_id"
    t.integer  "uploader_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token",          limit: 255
    t.integer  "node_id"
    t.integer  "comments_count",             default: 0
    t.integer  "section_id"
  end

  add_index "tutorials", ["token"], name: "index_tutorials_on_token", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                         limit: 255, default: "", null: false
    t.string   "encrypted_password",            limit: 255, default: "", null: false
    t.string   "reset_password_token",          limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                             default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",            limit: 255
    t.string   "last_sign_in_ip",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "topics_count",                              default: 0
    t.integer  "replies_count",                             default: 0
    t.string   "name",                          limit: 255
    t.string   "avatar",                        limit: 255
    t.integer  "school_id"
    t.string   "role",                          limit: 255
    t.string   "password_digest",               limit: 255
    t.string   "remember_token",                limit: 255
    t.text     "desc"
    t.integer  "course_purchase_records_count"
    t.integer  "joined_groups_count",                       default: 0
    t.string   "subject"
    t.string   "category"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tutorial_id"
    t.string   "token",       limit: 255
    t.integer  "lesson_id"
    t.string   "video_type",  limit: 255, default: "mp4"
  end

  add_index "videos", ["token"], name: "index_videos_on_token", using: :btree

  create_table "vip_classes", force: :cascade do |t|
    t.string   "subject"
    t.string   "category"
    t.integer  "questions_count"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "vipclasses", force: :cascade do |t|
    t.string   "category"
    t.string   "subject"
    t.integer  "questions_count"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
