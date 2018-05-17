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

ActiveRecord::Schema.define(version: 20180516102752) do

  create_table "answers", force: :cascade do |t|
    t.text     "content",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "option_id",  limit: 4
    t.integer  "result_id",  limit: 4
  end

  add_index "answers", ["option_id"], name: "index_answers_on_option_id", using: :btree
  add_index "answers", ["result_id"], name: "index_answers_on_result_id", using: :btree

  create_table "exams", force: :cascade do |t|
    t.integer  "score",      limit: 4
    t.integer  "status",     limit: 4, default: 0
    t.integer  "time",       limit: 4, default: 0
    t.integer  "user_id",    limit: 4
    t.integer  "subject_id", limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "exams", ["subject_id"], name: "index_exams_on_subject_id", using: :btree
  add_index "exams", ["user_id"], name: "index_exams_on_user_id", using: :btree

  create_table "options", force: :cascade do |t|
    t.string   "content",     limit: 255
    t.boolean  "correct"
    t.integer  "question_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "options", ["question_id"], name: "index_options_on_question_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.text     "content",       limit: 65535
    t.integer  "question_type", limit: 4
    t.integer  "state",         limit: 4,     default: 0
    t.boolean  "active",                      default: true
    t.integer  "subject_id",    limit: 4
    t.integer  "user_id",       limit: 4
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "questions", ["subject_id"], name: "index_questions_on_subject_id", using: :btree
  add_index "questions", ["user_id"], name: "index_questions_on_user_id", using: :btree

  create_table "results", force: :cascade do |t|
    t.boolean  "correct"
    t.integer  "question_id", limit: 4
    t.integer  "exam_id",     limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "results", ["exam_id"], name: "index_results_on_exam_id", using: :btree
  add_index "results", ["question_id"], name: "index_results_on_question_id", using: :btree

  create_table "subjects", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "chatwork_room_id",   limit: 255
    t.integer  "number_of_question", limit: 4
    t.integer  "duration",           limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "chatwork_api_key",       limit: 255
    t.string   "chatwork_id",            limit: 255
    t.boolean  "admin",                              default: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "provider",               limit: 255
    t.string   "token",                  limit: 255
    t.string   "refresh_token",          limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "answers", "options"
  add_foreign_key "answers", "results"
  add_foreign_key "exams", "subjects"
  add_foreign_key "exams", "users"
  add_foreign_key "options", "questions"
  add_foreign_key "questions", "subjects"
  add_foreign_key "questions", "users"
  add_foreign_key "results", "exams"
  add_foreign_key "results", "questions"
end
