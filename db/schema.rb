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

ActiveRecord::Schema.define(version: 20150716113417) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ldaps", force: :cascade do |t|
    t.string   "hostname",                         null: false
    t.integer  "port",               default: 389, null: false
    t.string   "basedn",                           null: false
    t.string   "filter"
    t.string   "login_mask",                       null: false
    t.string   "username_attribute",               null: false
    t.string   "name_attribute",                   null: false
    t.string   "lastname_attribute",               null: false
    t.string   "email_attribute",                  null: false
    t.integer  "lock_version",       default: 0,   null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "runs", force: :cascade do |t|
    t.string   "status",                   null: false
    t.datetime "scheduled_at",             null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.text     "output"
    t.integer  "schedule_id",              null: false
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "runs", ["schedule_id"], name: "index_runs_on_schedule_id", using: :btree
  add_index "runs", ["scheduled_at"], name: "index_runs_on_scheduled_at", using: :btree
  add_index "runs", ["status"], name: "index_runs_on_status", using: :btree

  create_table "schedules", force: :cascade do |t|
    t.datetime "start",                    null: false
    t.datetime "end"
    t.integer  "interval"
    t.string   "frequency"
    t.integer  "script_id",                null: false
    t.integer  "server_id"
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "name",                     null: false
  end

  add_index "schedules", ["frequency"], name: "index_schedules_on_frequency", using: :btree
  add_index "schedules", ["interval"], name: "index_schedules_on_interval", using: :btree
  add_index "schedules", ["name"], name: "index_schedules_on_name", using: :btree
  add_index "schedules", ["script_id"], name: "index_schedules_on_script_id", using: :btree
  add_index "schedules", ["server_id"], name: "index_schedules_on_server_id", using: :btree

  create_table "scripts", force: :cascade do |t|
    t.string   "name",                     null: false
    t.string   "file"
    t.text     "text"
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "parent_id"
  end

  add_index "scripts", ["parent_id"], name: "index_scripts_on_parent_id", using: :btree

  create_table "servers", force: :cascade do |t|
    t.string   "name",                     null: false
    t.string   "hostname",                 null: false
    t.string   "user"
    t.string   "password"
    t.string   "credential"
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                               null: false
    t.string   "lastname",                           null: false
    t.string   "email",                              null: false
    t.string   "password_digest",                    null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "auth_token",                         null: false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.integer  "lock_version",           default: 0, null: false
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["password_reset_token"], name: "index_users_on_password_reset_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.integer  "whodunnit"
    t.json     "object"
    t.json     "object_changes"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["whodunnit"], name: "index_versions_on_whodunnit", using: :btree

  add_foreign_key "runs", "schedules", on_update: :restrict, on_delete: :restrict
  add_foreign_key "schedules", "scripts", on_update: :restrict, on_delete: :restrict
  add_foreign_key "schedules", "servers", on_update: :restrict, on_delete: :restrict
  add_foreign_key "scripts", "scripts", column: "parent_id"
end
