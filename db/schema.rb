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

ActiveRecord::Schema.define(version: 20150505122617) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.integer  "project_id", null: false
    t.integer  "course_id",  null: false
    t.datetime "due_at",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "campuses", force: :cascade do |t|
    t.string   "name",       null: false
    t.json     "aliases"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.integer "instructor_id", null: false
    t.integer "topic_id",      null: false
    t.integer "campus_id",     null: false
    t.string  "organization",  null: false
    t.date    "start_on",      null: false
    t.json    "reflections",   null: false
  end

  add_index "courses", ["campus_id"], name: "index_courses_on_campus_id", using: :btree
  add_index "courses", ["instructor_id"], name: "index_courses_on_instructor_id", using: :btree
  add_index "courses", ["topic_id"], name: "index_courses_on_topic_id", using: :btree

  create_table "course_members", force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "user_id",   null: false
    t.integer "role_id",   null: false
  end

  add_index "course_members", ["course_id"], name: "index_course_members_on_course_id", using: :btree

  create_table "employments", force: :cascade do |t|
    t.integer "user_id"
    t.string  "teamwork_id"
    t.string  "first_name",        null: false
    t.string  "last_name",         null: false
    t.string  "email",             null: false
    t.integer "current_course_id"
    t.integer "campus_id"
    t.integer "topic_id"
  end

  add_index "employments", ["campus_id"], name: "index_employments_on_campus_id", using: :btree
  add_index "employments", ["topic_id"], name: "index_employments_on_topic_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.json     "data",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.integer "topic_id",    null: false
    t.string  "title",       null: false
    t.text    "description", null: false
  end

  add_index "projects", ["topic_id"], name: "index_projects_on_topic_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
  end

  add_index "roles", ["name"], name: "index_roles_on_name", unique: true, using: :btree

  create_table "student_assignments", force: :cascade do |t|
    t.integer "user_id",    null: false
    t.integer "student_id", null: false
    t.string  "issue_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string   "title",      null: false
    t.json     "aliases"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",               default: "", null: false
    t.boolean  "admin"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "course_members", "course"
  add_foreign_key "course_members", "user"
  add_foreign_key "course_members", "role"
  add_foreign_key "employments", "campuses"
  add_foreign_key "employments", "topics"
  add_foreign_key "identities", "users"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
end
