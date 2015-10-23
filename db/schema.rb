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

ActiveRecord::Schema.define(version: 20151023081335) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.float    "money",             default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "accountable_id"
    t.string   "accountable_type"
    t.integer  "total_income"
    t.integer  "total_expenditure"
  end

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "teacher_id"
    t.string   "token"
    t.text     "content"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "comments_count", default: 0
  end

  create_table "cash_operation_records", force: :cascade do |t|
    t.integer  "operator_id"
    t.integer  "account_id"
    t.float    "value"
    t.string   "type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "author_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consumption_records", force: :cascade do |t|
    t.integer  "fee_id"
    t.integer  "account_id"
    t.float    "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "corrections", force: :cascade do |t|
    t.text     "content"
    t.integer  "teacher_id"
    t.integer  "solution_id"
    t.string   "token"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "comments_count",       default: 0
    t.integer  "customized_course_id"
    t.string   "status",               default: "open", null: false
    t.integer  "homework_id"
    t.integer  "teacher_price"
    t.integer  "platform_price"
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
    t.string   "name"
    t.text     "desc"
    t.integer  "lessons_count",                 default: 0
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "price",                         default: 30.0
    t.integer  "teacher_id"
    t.string   "state",                         default: "unpublished"
    t.integer  "course_purchase_records_count"
    t.integer  "curriculum_id"
    t.string   "chapter"
    t.integer  "position",                      default: 0
    t.integer  "delete_topics_count",           default: 0
  end

  create_table "curriculums", force: :cascade do |t|
    t.integer  "teacher_id"
    t.integer  "teaching_program_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "courses_count",       default: 0
    t.integer  "lessons_count",       default: 0
    t.integer  "delete_topics_count", default: 0
  end

  create_table "customized_course_assignments", force: :cascade do |t|
    t.integer  "customized_course_id"
    t.integer  "teacher_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "customized_courses", force: :cascade do |t|
    t.integer  "student_id"
    t.string   "category",                   default: "高中"
    t.string   "subject",                    default: "数学"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "customized_tutorials_count", default: 0
    t.integer  "topics_count",               default: 0
    t.integer  "homeworks_count",            default: 0
    t.integer  "exercises_count",            default: 0
    t.integer  "tutorial_issues_count",      default: 0
    t.integer  "course_issues_count",        default: 0
    t.integer  "platform_price"
    t.integer  "customized_course_type",     default: 0
    t.integer  "teacher_price"
  end

  create_table "customized_tutorials", force: :cascade do |t|
    t.integer  "teacher_id"
    t.integer  "customized_course_id"
    t.string   "title"
    t.text     "content"
    t.integer  "position",              default: 0
    t.string   "token"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "topics_count",          default: 0
    t.integer  "exercises_count",       default: 0
    t.string   "status",                default: "open", null: false
    t.integer  "tutorial_issues_count", default: 0
    t.integer  "teacher_price"
    t.integer  "platform_price"
  end

  create_table "earning_records", force: :cascade do |t|
    t.integer  "fee_id"
    t.integer  "account_id"
    t.float    "percent"
    t.float    "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exercises", force: :cascade do |t|
    t.string   "token"
    t.string   "title"
    t.text     "content"
    t.integer  "teacher_id"
    t.integer  "customized_tutorial_id"
    t.integer  "solutions_count",        default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "comments_count",         default: 0
    t.integer  "student_id"
    t.integer  "customized_course_id"
  end

  create_table "faq_topics", force: :cascade do |t|
    t.string   "title"
    t.string   "user_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "faqs", force: :cascade do |t|
    t.string   "name"
    t.text     "desc"
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "faq_type"
    t.integer  "faq_topic_id"
    t.integer  "is_top",       default: 0
    t.string   "video_url"
  end

  add_index "faqs", ["user_id"], name: "index_faqs_on_user_id", using: :btree

  create_table "fees", force: :cascade do |t|
    t.integer  "customized_course_id"
    t.integer  "feeable_id"
    t.string   "feeable_type"
    t.float    "value"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.float    "price_per_minute"
    t.float    "video_duration"
  end

  create_table "homeworks", force: :cascade do |t|
    t.integer  "customized_course_id"
    t.integer  "teacher_id"
    t.string   "title"
    t.text     "content"
    t.string   "token"
    t.integer  "topics_count",           default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "solutions_count",        default: 0
    t.integer  "student_id"
    t.integer  "customized_tutorial_id"
    t.integer  "comments_count",         default: 0
    t.integer  "corrections_count",      default: 0
    t.string   "work_type"
  end

  create_table "learning_plan_assignments", force: :cascade do |t|
    t.integer  "learning_plan_id"
    t.integer  "teacher_id"
    t.integer  "answered_questions_count", default: 0
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "learning_plan_assignments", ["learning_plan_id", "teacher_id"], name: "unique_teacher", unique: true, using: :btree

  create_table "learning_plans", force: :cascade do |t|
    t.string   "duration_type"
    t.string   "state"
    t.integer  "student_id"
    t.integer  "vip_class_id"
    t.float    "price"
    t.datetime "begin_at"
    t.datetime "end_at"
    t.integer  "questions_count",          default: 0
    t.integer  "answered_questions_count", default: 0
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "lessons", force: :cascade do |t|
    t.string   "name"
    t.text     "desc"
    t.integer  "course_id"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "teacher_id"
    t.integer  "curriculum_id"
    t.string   "state",         default: "init"
    t.integer  "topics_count",  default: 0
    t.jsonb    "tags",          default: []
  end

  add_index "lessons", ["tags"], name: "index_lessons_on_tags", using: :gin

  create_table "messages", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "message_type"
    t.string   "status"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nodes", force: :cascade do |t|
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

  create_table "pictures", force: :cascade do |t|
    t.string   "name"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

  create_table "qa_faqs", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "qa_faq_type", default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "token"
  end

  create_table "qa_files", force: :cascade do |t|
    t.integer  "author_id"
    t.integer  "qa_fileable_id"
    t.string   "qa_fileable_type"
    t.string   "name"
    t.string   "qa_file_type"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "original_filename"
  end

  create_table "question_assignments", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "teacher_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.string   "token"
    t.integer  "student_id"
    t.integer  "answers_count",    default: 0
    t.integer  "vip_class_id"
    t.integer  "learning_plan_id"
    t.jsonb    "answers_info",     default: {}, null: false
    t.jsonb    "last_answer_info", default: {}, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "comments_count",   default: 0
  end

  add_index "questions", ["answers_info"], name: "index_questions_on_answers_info", using: :gin
  add_index "questions", ["last_answer_info"], name: "index_questions_on_last_answer_info", using: :gin

  create_table "recharge_codes", force: :cascade do |t|
    t.integer  "money",        default: 500
    t.string   "code"
    t.integer  "admin_id"
    t.string   "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_id"
    t.integer  "lock_version", default: 0
  end

  add_index "recharge_codes", ["code"], name: "index_recharge_codes_on_code", using: :btree

  create_table "recharge_records", force: :cascade do |t|
    t.integer  "student_id"
    t.string   "code"
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
    t.integer  "school_id"
    t.string   "batch_id"
  end

  create_table "replies", force: :cascade do |t|
    t.text     "content"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.integer  "author_id"
    t.integer  "customized_course_id"
    t.string   "status",                 default: "open", null: false
    t.string   "type"
    t.integer  "customized_tutorial_id"
    t.integer  "teacher_price"
    t.integer  "platform_price"
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
    t.string   "name"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "solutions", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "solutionable_id"
    t.integer  "student_id"
    t.string   "token"
    t.integer  "corrections_count",       default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "comments_count",          default: 0
    t.string   "solutionable_type"
    t.integer  "customized_course_id"
    t.datetime "first_handle_created_at"
    t.datetime "last_handle_created_at"
    t.integer  "first_handle_author_id"
    t.integer  "last_handle_author_id"
  end

  create_table "teaching_programs", force: :cascade do |t|
    t.string   "name"
    t.string   "category"
    t.string   "grade"
    t.string   "subject"
    t.jsonb    "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teaching_videos", force: :cascade do |t|
    t.string   "name"
    t.string   "token"
    t.integer  "vip_class"
    t.integer  "teacher_id"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "video_type",   default: "mp4"
    t.string   "state",        default: "not_convert"
    t.string   "convert_name"
  end

  add_index "teaching_videos", ["token"], name: "index_teaching_videos_on_token", using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "replies_count",           default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.integer  "course_id"
    t.integer  "author_id"
    t.integer  "curriculum_id"
    t.integer  "topicable_id"
    t.integer  "delete_learning_plan_id"
    t.integer  "teacher_id"
    t.string   "topicable_type"
    t.integer  "customized_course_id"
    t.string   "type"
    t.integer  "customized_tutorial_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                         default: "",    null: false
    t.string   "encrypted_password",            default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                 default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "topics_count",                  default: 0
    t.integer  "replies_count",                 default: 0
    t.string   "name"
    t.string   "avatar"
    t.integer  "school_id"
    t.string   "role"
    t.string   "password_digest"
    t.string   "remember_token"
    t.text     "desc"
    t.integer  "course_purchase_records_count"
    t.integer  "joined_groups_count",           default: 0
    t.string   "subject"
    t.string   "category"
    t.string   "mobile"
    t.boolean  "pass",                          default: false
    t.string   "grade"
    t.string   "nick_name"
    t.integer  "workstation_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.integer  "videoable_id"
    t.string   "video_type",     default: "mp4"
    t.string   "convert_name"
    t.string   "state",          default: "not_convert"
    t.string   "videoable_type"
    t.integer  "author_id"
    t.integer  "duration"
  end

  add_index "videos", ["token"], name: "index_videos_on_token", using: :btree

  create_table "vip_classes", force: :cascade do |t|
    t.string   "subject"
    t.string   "category"
    t.integer  "questions_count"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "workstations", force: :cascade do |t|
    t.string   "name"
    t.integer  "city_id"
    t.string   "address"
    t.integer  "tel"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
