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

ActiveRecord::Schema.define(version: 20160627065822) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.float    "money",             default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "accountable_id"
    t.string   "accountable_type"
    t.float    "total_income",      default: 0.0, null: false
    t.float    "total_expenditure", default: 0.0, null: false
  end

  create_table "action_records", force: :cascade do |t|
    t.integer  "operator_id"
    t.integer  "customized_course_id"
    t.string   "actionable_type"
    t.integer  "actionable_id"
    t.string   "name"
    t.string   "type"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "from"
    t.string   "to"
    t.string   "event"
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

  create_table "cash_accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.decimal  "balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "cash_accounts", ["user_id"], name: "index_cash_accounts_on_user_id", using: :btree

  create_table "cash_operation_records", force: :cascade do |t|
    t.integer  "operator_id"
    t.integer  "account_id"
    t.float    "value"
    t.string   "type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "change_records", force: :cascade do |t|
    t.integer  "cash_account_id"
    t.decimal  "before",          precision: 10, scale: 2
    t.decimal  "after",           precision: 10, scale: 2
    t.decimal  "different",       precision: 10, scale: 2
    t.integer  "ref_id"
    t.string   "ref_type"
    t.string   "remark"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "change_records", ["cash_account_id"], name: "index_change_records_on_cash_account_id", using: :btree
  add_index "change_records", ["ref_type", "ref_id"], name: "index_change_records_on_ref_type_and_ref_id", using: :btree

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
    t.integer  "customized_course_id"
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
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "comments_count",         default: 0
    t.integer  "customized_course_id"
    t.string   "status",                 default: "open", null: false
    t.integer  "homework_id"
    t.float    "teacher_price"
    t.float    "platform_price"
    t.string   "type"
    t.integer  "customized_tutorial_id"
    t.integer  "examination_id"
    t.integer  "last_operator_id"
    t.integer  "template_id"
  end

  create_table "course_library_course_publications", force: :cascade do |t|
    t.boolean  "publish_lecture_switch", default: false
    t.integer  "customized_course_id"
    t.integer  "course_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "course_library_courses", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "directory_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "position"
  end

  create_table "course_library_directories", force: :cascade do |t|
    t.string   "title"
    t.integer  "parent_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "syllabus_id"
    t.integer  "position"
  end

  create_table "course_library_homework_publications", force: :cascade do |t|
    t.integer  "homework_id"
    t.integer  "course_publication_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "course_library_homeworks", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "course_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "course_library_solutions", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "homework_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "course_library_syllabuses", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "author_id"
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

  create_table "customized_course_message_boards", force: :cascade do |t|
    t.integer  "customized_course_id"
    t.integer  "customized_course_messages_count",        default: 0
    t.integer  "customized_course_message_replies_count", default: 0
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  create_table "customized_course_message_replies", force: :cascade do |t|
    t.integer  "customized_course_message_id"
    t.integer  "customized_course_message_board_id"
    t.integer  "customized_course_id"
    t.text     "content"
    t.string   "token"
    t.integer  "author_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "last_operator_id"
  end

  create_table "customized_course_messages", force: :cascade do |t|
    t.integer  "customized_course_message_board_id"
    t.string   "title"
    t.text     "content"
    t.integer  "author_id"
    t.integer  "customized_course_message_replies_count", default: 0
    t.integer  "customized_course_id"
    t.string   "token"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "last_operator_id"
  end

  create_table "customized_courses", force: :cascade do |t|
    t.integer  "student_id"
    t.string   "category",                   default: "高中"
    t.string   "subject",                    default: "数学"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "customized_tutorials_count", default: 0
    t.integer  "topics_count",               default: 0
    t.integer  "homeworks_count",            default: 0
    t.integer  "exercises_count",            default: 0
    t.integer  "tutorial_issues_count",      default: 0
    t.integer  "course_issues_count",        default: 0
    t.float    "platform_price"
    t.integer  "customized_course_type",     default: 0
    t.float    "teacher_price"
    t.integer  "creator_id"
    t.integer  "workstation_id"
    t.boolean  "is_keep_account",            default: false
    t.text     "desc"
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
    t.float    "teacher_price"
    t.float    "platform_price"
    t.integer  "last_operator_id"
    t.integer  "course_publication_id"
  end

  create_table "earning_records", force: :cascade do |t|
    t.integer  "fee_id"
    t.integer  "account_id"
    t.float    "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "price"
  end

  create_table "examinations", force: :cascade do |t|
    t.integer  "customized_course_id"
    t.integer  "teacher_id"
    t.string   "title"
    t.text     "content"
    t.string   "token"
    t.integer  "topics_count",            default: 0
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "solutions_count",         default: 0
    t.integer  "student_id"
    t.integer  "customized_tutorial_id"
    t.integer  "comments_count",          default: 0
    t.integer  "corrections_count",       default: 0
    t.string   "work_type"
    t.string   "type"
    t.string   "state",                   default: "new"
    t.integer  "last_operator_id"
    t.datetime "first_handled_at"
    t.datetime "completed_at"
    t.datetime "last_handled_at"
    t.datetime "last_redone_at"
    t.integer  "homework_publication_id"
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
    t.float    "video_duration"
    t.float    "platform_price"
    t.float    "teacher_price"
    t.float    "sale_price"
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

  create_table "live_studio_channels", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "course_id"
    t.string   "remote_id",  limit: 100
    t.integer  "state",                  default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "live_studio_channels", ["course_id"], name: "index_live_studio_channels_on_course_id", using: :btree

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

  add_index "live_studio_courses", ["teacher_id"], name: "index_live_studio_courses_on_teacher_id", using: :btree
  add_index "live_studio_courses", ["workstation_id"], name: "index_live_studio_courses_on_workstation_id", using: :btree

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
    t.integer  "pos",                       default: 0
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "live_studio_lessons", ["course_id"], name: "index_live_studio_lessons_on_course_id", using: :btree
  add_index "live_studio_lessons", ["teacher_id"], name: "index_live_studio_lessons_on_teacher_id", using: :btree

  create_table "live_studio_play_records", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "course_id"
    t.integer  "lesson_id"
    t.datetime "start_time_at"
    t.datetime "end_time_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "live_studio_play_records", ["course_id"], name: "index_live_studio_play_records_on_course_id", using: :btree
  add_index "live_studio_play_records", ["lesson_id"], name: "index_live_studio_play_records_on_lesson_id", using: :btree
  add_index "live_studio_play_records", ["student_id"], name: "index_live_studio_play_records_on_student_id", using: :btree

  create_table "live_studio_streams", force: :cascade do |t|
    t.string   "protocol",   limit: 20
    t.string   "address",    limit: 255
    t.integer  "channel_id"
    t.integer  "user_count",             default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "live_studio_streams", ["channel_id"], name: "index_live_studio_streams_on_channel_id", using: :btree

  create_table "live_studio_tickets", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "student_id"
    t.integer  "lesson_id"
    t.integer  "state",      limit: 2, default: 0
    t.string   "type"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "live_studio_tickets", ["course_id"], name: "index_live_studio_tickets_on_course_id", using: :btree
  add_index "live_studio_tickets", ["lesson_id"], name: "index_live_studio_tickets_on_lesson_id", using: :btree
  add_index "live_studio_tickets", ["student_id"], name: "index_live_studio_tickets_on_student_id", using: :btree

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

  create_table "notifications", force: :cascade do |t|
    t.string   "type"
    t.integer  "receiver_id"
    t.string   "notificationable_type"
    t.integer  "notificationable_id"
    t.integer  "operator_id"
    t.boolean  "read",                  default: false
    t.string   "action_name"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "customized_course_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string   "order_no",     limit: 64
    t.integer  "user_id"
    t.integer  "product_id"
    t.string   "product_type"
    t.decimal  "total_money",             precision: 6, scale: 2, default: 0.0
    t.integer  "state"
    t.integer  "pay_type",     limit: 2
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
  end

  add_index "orders", ["order_no"], name: "index_orders_on_order_no", using: :btree
  add_index "orders", ["product_type", "product_id"], name: "index_orders_on_product_type_and_product_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "payment_orders", force: :cascade do |t|
    t.string   "order_no",     limit: 64,                                       null: false
    t.integer  "user_id"
    t.integer  "product_id"
    t.string   "product_type"
    t.decimal  "total_money",             precision: 8, scale: 2, default: 0.0
    t.integer  "status",                                          default: 0,   null: false
    t.integer  "pay_type",                                        default: 0,   null: false
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
  end

  add_index "payment_orders", ["product_type", "product_id"], name: "index_payment_orders_on_product_type_and_product_id", using: :btree
  add_index "payment_orders", ["user_id"], name: "index_payment_orders_on_user_id", using: :btree

  create_table "picture_quoters", force: :cascade do |t|
    t.integer  "picture_id"
    t.integer  "file_quoter_id"
    t.string   "file_quoter_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "name"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.integer  "author_id"
  end

  create_table "qa_faqs", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "qa_faq_type", default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "token"
  end

  create_table "qa_file_quoters", force: :cascade do |t|
    t.integer  "qa_file_id"
    t.integer  "file_quoter_id"
    t.string   "file_quoter_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
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

  create_table "qawechat_wechat_users", force: :cascade do |t|
    t.string   "openid"
    t.text     "userinfo"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "user_id"
    t.string   "remember_token"
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
    t.float    "teacher_price"
    t.float    "platform_price"
    t.integer  "last_operator_id"
    t.integer  "comments_count",         default: 0
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
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "comments_count",          default: 0
    t.string   "solutionable_type"
    t.integer  "customized_course_id"
    t.datetime "first_handle_created_at"
    t.datetime "last_handle_created_at"
    t.integer  "first_handle_author_id"
    t.integer  "last_handle_author_id"
    t.string   "type"
    t.integer  "examination_id"
    t.integer  "customized_tutorial_id"
    t.string   "state",                   default: "new"
    t.integer  "last_operator_id"
    t.datetime "first_handled_at"
    t.datetime "completed_at"
    t.datetime "last_handled_at"
    t.datetime "last_redone_at"
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
    t.integer  "last_operator_id"
    t.datetime "first_handled_at"
    t.datetime "completed_at"
    t.datetime "last_handled_at"
    t.datetime "last_redone_at"
    t.string   "state",                   default: "new"
    t.integer  "comments_count",          default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                     default: "",    null: false
    t.string   "encrypted_password",                        default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                             default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "topics_count",                              default: 0
    t.integer  "replies_count",                             default: 0
    t.string   "name"
    t.string   "avatar"
    t.integer  "school_id"
    t.string   "role"
    t.string   "password_digest"
    t.string   "remember_token"
    t.text     "desc"
    t.integer  "course_purchase_records_count"
    t.integer  "joined_groups_count",                       default: 0
    t.string   "subject"
    t.string   "category"
    t.string   "mobile"
    t.boolean  "pass",                                      default: false
    t.string   "grade"
    t.string   "nick_name"
    t.string   "parent_phone"
    t.integer  "workstation_id"
    t.string   "type",                          limit: 100
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["workstation_id"], name: "index_users_on_workstation_id", using: :btree

  create_table "video_quoters", force: :cascade do |t|
    t.integer  "video_id"
    t.integer  "file_quoter_id"
    t.string   "file_quoter_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

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
    t.string   "tel"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "manager_id"
  end

  add_foreign_key "cash_accounts", "users"
  add_foreign_key "orders", "users"
end
