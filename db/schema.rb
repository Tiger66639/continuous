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

ActiveRecord::Schema.define(version: 20141217054735) do

  create_table "accounts", force: true do |t|
    t.string   "uuid"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "checks", force: true do |t|
    t.string   "name"
    t.string   "checktype"
    t.string   "uuid"
    t.text     "information"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "checks_dashboards", force: true do |t|
    t.integer "check_id"
    t.integer "dashboard_id"
  end

  create_table "checks_scripts", force: true do |t|
    t.integer "check_id"
    t.integer "script_id"
  end

  create_table "cistacks", force: true do |t|
    t.string   "name"
    t.string   "uuid"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ciworkers", force: true do |t|
    t.string   "name"
    t.string   "image"
    t.string   "flavor"
    t.string   "uuid"
    t.string   "rebuild"
    t.integer  "account_id"
    t.integer  "cistack_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dashboards", force: true do |t|
    t.string   "name"
    t.string   "uuid"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "environments", force: true do |t|
    t.string   "name"
    t.string   "uuid"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "environments_workflows", force: true do |t|
    t.integer "environment_id"
    t.integer "workflow_id"
  end

  create_table "groups", force: true do |t|
    t.string   "uuid"
    t.string   "name"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_users", force: true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "permissionroles", force: true do |t|
    t.integer  "grant"
    t.integer  "permission_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", force: true do |t|
    t.string   "name"
    t.string   "module"
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissionusers", force: true do |t|
    t.integer  "grant"
    t.integer  "permission_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.string   "uuid"
    t.integer  "account_id"
    t.integer  "cistack_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "replicas", force: true do |t|
    t.string   "name"
    t.string   "destination"
    t.string   "uuid"
    t.integer  "account_id"
    t.integer  "cistack_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "repositories", force: true do |t|
    t.string   "name"
    t.string   "uuid"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", force: true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "scripts", force: true do |t|
    t.string   "name"
    t.text     "content"
    t.string   "uuid"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "tasks", force: true do |t|
    t.string   "name"
    t.string   "tasktype"
    t.string   "uuid"
    t.text     "command"
    t.text     "description"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks_workflows", force: true do |t|
    t.integer "task_id"
    t.integer "workflow_id"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "name"
    t.string   "email"
    t.string   "uuid"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workflows", force: true do |t|
    t.string   "name"
    t.string   "priority"
    t.string   "uuid"
    t.text     "description"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
