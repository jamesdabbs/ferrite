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

ActiveRecord::Schema.define(version: 20150525213215) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.integer  "project_id", null: false
    t.integer  "course_id",  null: false
    t.datetime "due_at",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "assignments", ["course_id"], name: "index_assignments_on_course_id", using: :btree

  create_table "campuses", force: :cascade do |t|
    t.string   "name",       null: false
    t.json     "aliases"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "campuses", ["name"], name: "index_campuses_on_name", unique: true, using: :btree

  create_table "course_members", force: :cascade do |t|
    t.integer "course_id"
    t.integer "user_id"
    t.string  "role",      null: false
  end

  add_index "course_members", ["course_id"], name: "index_course_members_on_course_id", using: :btree
  add_index "course_members", ["user_id"], name: "index_course_members_on_user_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.integer "instructor_id", null: false
    t.integer "topic_id",      null: false
    t.integer "campus_id",     null: false
    t.string  "organization",  null: false
    t.date    "start_on",      null: false
    t.json    "reflections",   null: false
    t.integer "slack_team_id"
    t.string  "slack_room"
  end

  add_index "courses", ["campus_id"], name: "index_courses_on_campus_id", using: :btree
  add_index "courses", ["instructor_id"], name: "index_courses_on_instructor_id", using: :btree
  add_index "courses", ["slack_team_id"], name: "index_courses_on_slack_team_id", using: :btree
  add_index "courses", ["topic_id"], name: "index_courses_on_topic_id", using: :btree

  create_table "employments", force: :cascade do |t|
    t.integer "user_id",           null: false
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

  add_index "identities", ["provider", "uid"], name: "index_identities_on_provider_and_uid", using: :btree
  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.integer "topic_id",    null: false
    t.string  "title",       null: false
    t.text    "description", null: false
  end

  add_index "projects", ["topic_id"], name: "index_projects_on_topic_id", using: :btree

  create_table "slack_team_memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.string   "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "slack_team_memberships", ["team_id"], name: "index_slack_team_memberships_on_team_id", using: :btree
  add_index "slack_team_memberships", ["user_id"], name: "index_slack_team_memberships_on_user_id", using: :btree
  add_index "slack_team_memberships", ["username"], name: "index_slack_team_memberships_on_username", using: :btree

  create_table "slack_teams", force: :cascade do |t|
    t.string   "name"
    t.string   "webhook_url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "submission_reviews", force: :cascade do |t|
    t.integer  "reviewer_id"
    t.integer  "submission_id"
    t.integer  "score"
    t.json     "comments"
    t.datetime "created_at"
  end

  add_index "submission_reviews", ["submission_id"], name: "index_submission_reviews_on_submission_id", using: :btree

  create_table "submissions", force: :cascade do |t|
    t.integer  "user_id",       null: false
    t.integer  "assignment_id", null: false
    t.string   "repo"
    t.string   "commit"
    t.integer  "comfort"
    t.integer  "hours_spent"
    t.integer  "happiness"
    t.json     "comments"
    t.datetime "created_at"
  end

  add_index "submissions", ["assignment_id"], name: "index_submissions_on_assignment_id", using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "title",      null: false
    t.json     "aliases"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "topics", ["title"], name: "index_topics_on_title", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",               default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                default: "", null: false
    t.integer  "active_course_id"
    t.string   "github_username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "assignments", "courses"
  add_foreign_key "assignments", "projects"
  add_foreign_key "course_members", "courses"
  add_foreign_key "course_members", "users"
  add_foreign_key "courses", "campuses"
  add_foreign_key "courses", "employments", column: "instructor_id"
  add_foreign_key "courses", "slack_teams"
  add_foreign_key "courses", "topics"
  add_foreign_key "employments", "campuses"
  add_foreign_key "employments", "topics"
  add_foreign_key "employments", "users"
  add_foreign_key "identities", "users"
  add_foreign_key "projects", "topics"
  add_foreign_key "slack_team_memberships", "slack_teams", column: "team_id"
  add_foreign_key "slack_team_memberships", "users"
  add_foreign_key "submission_reviews", "submissions"
  add_foreign_key "submission_reviews", "users", column: "reviewer_id"
  add_foreign_key "submissions", "assignments"
  add_foreign_key "submissions", "users"
end
