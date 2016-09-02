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

ActiveRecord::Schema.define(version: 20160902071332) do

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

  create_table "cash_operation_records", force: :cascade do |t|
    t.integer  "operator_id"
    t.integer  "account_id"
    t.float    "value"
    t.string   "type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "chat_accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "accid",      limit: 32
    t.string   "token",      limit: 32
    t.string   "name",       limit: 128
    t.string   "icon"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "chat_accounts", ["user_id"], name: "chat_accounts_user_id_unique", unique: true, using: :btree
  add_index "chat_accounts", ["user_id"], name: "index_chat_accounts_on_user_id", using: :btree

  create_table "chat_join_records", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "team_id"
    t.string   "nick_name",  limit: 64
    t.string   "role",       limit: 16
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "chat_join_records", ["account_id"], name: "index_chat_join_records_on_account_id", using: :btree
  add_index "chat_join_records", ["team_id"], name: "index_chat_join_records_on_team_id", using: :btree

  create_table "chat_team_announcements", force: :cascade do |t|
    t.integer  "team_id"
    t.text     "announcement"
    t.datetime "edit_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "chat_teams", force: :cascade do |t|
    t.string   "team_id",               limit: 32
    t.string   "name",                  limit: 64
    t.integer  "live_studio_course_id"
    t.string   "owner",                 limit: 32
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "chat_teams", ["live_studio_course_id"], name: "chat_teams_course_id_unique", unique: true, using: :btree
  add_index "chat_teams", ["live_studio_course_id"], name: "index_chat_teams_on_live_studio_course_id", using: :btree

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "province_id"
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
    t.integer  "status",                 default: 0
    t.datetime "deleted_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "live_studio_channels", ["course_id"], name: "index_live_studio_channels_on_course_id", using: :btree

  create_table "live_studio_courses", force: :cascade do |t|
    t.string   "name",                   limit: 100,                                       null: false
    t.integer  "teacher_id"
    t.integer  "workstation_id",                                                           null: false
    t.integer  "status",                                                     default: 0
    t.text     "description"
    t.decimal  "price",                              precision: 8, scale: 2, default: 0.0
    t.decimal  "lesson_price",                       precision: 8, scale: 2, default: 0.0
    t.integer  "teacher_percentage",                                         default: 0
    t.integer  "lesson_count",                                               default: 0
    t.integer  "preset_lesson_count",                                        default: 0
    t.integer  "completed_lesson_count",                                     default: 0
    t.datetime "deleted_at"
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
    t.string   "subject"
    t.string   "grade"
    t.string   "publicize"
    t.integer  "buy_tickets_count",                                          default: 0
    t.date     "class_date"
    t.datetime "published_at"
  end

  add_index "live_studio_courses", ["class_date"], name: "index_live_studio_courses_on_class_date", using: :btree
  add_index "live_studio_courses", ["preset_lesson_count"], name: "index_live_studio_courses_on_preset_lesson_count", using: :btree
  add_index "live_studio_courses", ["price"], name: "index_live_studio_courses_on_price", using: :btree
  add_index "live_studio_courses", ["published_at"], name: "index_live_studio_courses_on_published_at", using: :btree
  add_index "live_studio_courses", ["teacher_id"], name: "index_live_studio_courses_on_teacher_id", using: :btree
  add_index "live_studio_courses", ["workstation_id"], name: "index_live_studio_courses_on_workstation_id", using: :btree

  create_table "live_studio_lessons", force: :cascade do |t|
    t.string   "name",           limit: 100
    t.integer  "course_id"
    t.integer  "teacher_id"
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
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.datetime "heartbeat_time"
  end

  add_index "live_studio_lessons", ["course_id"], name: "index_live_studio_lessons_on_course_id", using: :btree
  add_index "live_studio_lessons", ["teacher_id"], name: "index_live_studio_lessons_on_teacher_id", using: :btree

  create_table "live_studio_live_sessions", force: :cascade do |t|
    t.integer  "lesson_id"
    t.string   "token",           limit: 32
    t.integer  "heartbeat_count"
    t.integer  "duration"
    t.datetime "heartbeat_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "live_studio_live_sessions", ["lesson_id"], name: "index_live_studio_live_sessions_on_lesson_id", using: :btree

  create_table "live_studio_play_records", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.integer  "lesson_id"
    t.integer  "ticket_id"
    t.datetime "start_time_at"
    t.datetime "end_time_at"
    t.datetime "deleted_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "tp",            limit: 10
  end

  add_index "live_studio_play_records", ["course_id"], name: "index_live_studio_play_records_on_course_id", using: :btree
  add_index "live_studio_play_records", ["lesson_id"], name: "index_live_studio_play_records_on_lesson_id", using: :btree
  add_index "live_studio_play_records", ["ticket_id"], name: "index_live_studio_play_records_on_ticket_id", using: :btree
  add_index "live_studio_play_records", ["user_id"], name: "index_live_studio_play_records_on_user_id", using: :btree

  create_table "live_studio_streams", force: :cascade do |t|
    t.string   "protocol",   limit: 20
    t.string   "address",    limit: 255
    t.integer  "channel_id"
    t.integer  "user_count",             default: 0
    t.string   "type",       limit: 100
    t.datetime "deleted_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "live_studio_streams", ["channel_id"], name: "index_live_studio_streams_on_channel_id", using: :btree

  create_table "live_studio_tickets", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "student_id"
    t.integer  "lesson_id"
    t.integer  "status",       limit: 2,                         default: 0
    t.integer  "buy_count",    limit: 8,                         default: 0
    t.integer  "used_count",   limit: 8,                         default: 0
    t.string   "type"
    t.decimal  "lesson_price",           precision: 8, scale: 2, default: 0.0
    t.datetime "deleted_at"
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
  end

  add_index "live_studio_tickets", ["course_id"], name: "index_live_studio_tickets_on_course_id", using: :btree
  add_index "live_studio_tickets", ["lesson_id"], name: "index_live_studio_tickets_on_lesson_id", using: :btree
  add_index "live_studio_tickets", ["student_id"], name: "index_live_studio_tickets_on_student_id", using: :btree

  create_table "login_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "digest_token", limit: 64
    t.integer  "client_type"
    t.integer  "platform"
    t.datetime "expired_at"
    t.string   "login_ip"
    t.datetime "login_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "login_tokens", ["digest_token"], name: "index_login_tokens_on_digest_token", using: :btree
  add_index "login_tokens", ["user_id"], name: "index_login_tokens_on_user_id", using: :btree

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

  create_table "payment_billings", force: :cascade do |t|
    t.integer  "target_id"
    t.string   "target_type"
    t.decimal  "total_money", precision: 8, scale: 2
    t.datetime "deleted_at"
    t.string   "summary"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "payment_billings", ["target_type", "target_id"], name: "index_payment_billings_on_target_type_and_target_id", using: :btree

  create_table "payment_cash_accounts", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.decimal  "balance",    precision: 8, scale: 2, default: 0.0
    t.datetime "deleted_at"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  add_index "payment_cash_accounts", ["owner_type", "owner_id"], name: "index_payment_cash_accounts_on_owner_type_and_owner_id", using: :btree

  create_table "payment_change_records", force: :cascade do |t|
    t.integer  "cash_account_id"
    t.decimal  "different",       precision: 8, scale: 2, default: 0.0
    t.decimal  "before",          precision: 8, scale: 2, default: 0.0
    t.decimal  "after",           precision: 8, scale: 2, default: 0.0
    t.integer  "billing_id"
    t.string   "summary"
    t.datetime "deleted_at"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  add_index "payment_change_records", ["billing_id"], name: "index_payment_change_records_on_billing_id", using: :btree
  add_index "payment_change_records", ["cash_account_id"], name: "index_payment_change_records_on_cash_account_id", using: :btree
  add_index "payment_change_records", ["owner_type", "owner_id"], name: "index_payment_change_records_on_owner_type_and_owner_id", using: :btree

  create_table "payment_orders", force: :cascade do |t|
    t.string   "order_no",     limit: 64,                                            null: false
    t.integer  "user_id"
    t.integer  "product_id"
    t.string   "product_type"
    t.decimal  "total_money",             precision: 8, scale: 2, default: 0.0
    t.integer  "status",                                          default: 0,        null: false
    t.integer  "pay_type",                                        default: 0,        null: false
    t.string   "pay_url"
    t.string   "remote_ip"
    t.datetime "deleted_at"
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.string   "prepay_id"
    t.string   "nonce_str"
    t.string   "trade_type",   limit: 16,                         default: "NATIVE"
    t.datetime "pay_at"
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

  create_table "provinces", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "qr_codes", force: :cascade do |t|
    t.string   "code"
    t.integer  "qr_codeable_id"
    t.string   "qr_codeable_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
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

  create_table "softwares", force: :cascade do |t|
    t.string   "logo"
    t.string   "title"
    t.string   "sub_title"
    t.text     "desc"
    t.string   "role"
    t.string   "version"
    t.integer  "platform"
    t.string   "download_links"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.text     "description"
    t.integer  "status",         default: 0
    t.boolean  "enforce"
    t.datetime "running_at"
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
    t.string   "email"
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
    t.integer  "province_id"
    t.integer  "city_id"
    t.integer  "gender",                                    default: 0
    t.date     "birthday"
    t.string   "highest_education"
    t.integer  "teaching_years"
    t.string   "grade_range"
    t.string   "login_mobile"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["login_mobile"], name: "index_users_on_login_mobile", unique: true, using: :btree
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

end
