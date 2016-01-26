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

ActiveRecord::Schema.define(version: 20160125210209) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text     "text",       null: false
    t.integer  "user_id",    null: false
    t.integer  "issue_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "file"
  end

  add_index "comments", ["issue_id"], name: "index_comments_on_issue_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "databases", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "driver",      null: false
    t.string   "description", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "databases", ["name"], name: "index_databases_on_name", using: :btree

  create_table "dependencies", force: :cascade do |t|
    t.integer  "dependent_id", null: false
    t.integer  "schedule_id",  null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "dependencies", ["dependent_id"], name: "index_dependencies_on_dependent_id", using: :btree
  add_index "dependencies", ["schedule_id"], name: "index_dependencies_on_schedule_id", using: :btree

  create_table "descriptions", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "value",      null: false
    t.integer  "script_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "descriptions", ["script_id"], name: "index_descriptions_on_script_id", using: :btree

  create_table "descriptors", force: :cascade do |t|
    t.string   "name",                     null: false
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "dispatchers", force: :cascade do |t|
    t.integer  "schedule_id"
    t.integer  "rule_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "dispatchers", ["rule_id"], name: "index_dispatchers_on_rule_id", using: :btree
  add_index "dispatchers", ["schedule_id"], name: "index_dispatchers_on_schedule_id", using: :btree

  create_table "issues", force: :cascade do |t|
    t.string   "status",                   null: false
    t.text     "description"
    t.jsonb    "data"
    t.integer  "run_id",                   null: false
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "issues", ["created_at"], name: "index_issues_on_created_at", using: :btree
  add_index "issues", ["data"], name: "index_issues_on_data", using: :gin
  add_index "issues", ["run_id"], name: "index_issues_on_run_id", using: :btree
  add_index "issues", ["status"], name: "index_issues_on_status", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.integer  "schedule_id"
    t.integer  "server_id"
    t.integer  "script_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "jobs", ["schedule_id"], name: "index_jobs_on_schedule_id", using: :btree
  add_index "jobs", ["script_id"], name: "index_jobs_on_script_id", using: :btree
  add_index "jobs", ["server_id"], name: "index_jobs_on_server_id", using: :btree

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
    t.jsonb    "options"
    t.string   "roles_attribute",                  null: false
  end

  create_table "outputs", force: :cascade do |t|
    t.text     "text"
    t.integer  "trigger_id", null: false
    t.integer  "run_id",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "outputs", ["created_at"], name: "index_outputs_on_created_at", using: :btree
  add_index "outputs", ["run_id"], name: "index_outputs_on_run_id", using: :btree
  add_index "outputs", ["trigger_id"], name: "index_outputs_on_trigger_id", using: :btree

  create_table "properties", force: :cascade do |t|
    t.string   "key",         null: false
    t.string   "value",       null: false
    t.integer  "database_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "properties", ["database_id"], name: "index_properties_on_database_id", using: :btree

  create_table "requires", force: :cascade do |t|
    t.integer  "caller_id",  null: false
    t.integer  "script_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "requires", ["caller_id"], name: "index_requires_on_caller_id", using: :btree
  add_index "requires", ["script_id"], name: "index_requires_on_script_id", using: :btree

  create_table "rules", force: :cascade do |t|
    t.string   "name",                         null: false
    t.boolean  "enabled",      default: false, null: false
    t.integer  "lock_version", default: 0,     null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "rules", ["name"], name: "index_rules_on_name", using: :btree

  create_table "runs", force: :cascade do |t|
    t.string   "status",                   null: false
    t.datetime "scheduled_at",             null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.text     "output"
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "job_id"
    t.jsonb    "data"
  end

  add_index "runs", ["data"], name: "index_runs_on_data", using: :gin
  add_index "runs", ["job_id"], name: "index_runs_on_job_id", using: :btree
  add_index "runs", ["scheduled_at"], name: "index_runs_on_scheduled_at", using: :btree
  add_index "runs", ["status"], name: "index_runs_on_status", using: :btree

  create_table "schedules", force: :cascade do |t|
    t.datetime "start",                    null: false
    t.datetime "end"
    t.integer  "interval"
    t.string   "frequency"
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "name",                     null: false
    t.datetime "scheduled_at"
  end

  add_index "schedules", ["frequency"], name: "index_schedules_on_frequency", using: :btree
  add_index "schedules", ["interval"], name: "index_schedules_on_interval", using: :btree
  add_index "schedules", ["name"], name: "index_schedules_on_name", using: :btree
  add_index "schedules", ["scheduled_at"], name: "index_schedules_on_scheduled_at", using: :btree

  create_table "scripts", force: :cascade do |t|
    t.string   "name",                            null: false
    t.string   "file"
    t.text     "text"
    t.integer  "lock_version",        default: 0, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "core"
    t.integer  "active_issues_count", default: 0, null: false
  end

  add_index "scripts", ["active_issues_count"], name: "index_scripts_on_active_issues_count", using: :btree
  add_index "scripts", ["core"], name: "index_scripts_on_core", using: :btree
  add_index "scripts", ["name"], name: "index_scripts_on_name", using: :btree

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

  add_index "servers", ["name"], name: "index_servers_on_name", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "issue_id",   null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "subscriptions", ["issue_id"], name: "index_subscriptions_on_issue_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        null: false
    t.integer  "taggable_id",   null: false
    t.string   "taggable_type", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",                            null: false
    t.integer  "lock_version", default: 0,        null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "kind",         default: "script", null: false
  end

  add_index "tags", ["kind"], name: "index_tags_on_kind", using: :btree
  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree

  create_table "triggers", force: :cascade do |t|
    t.integer  "rule_id",                  null: false
    t.text     "callback",                 null: false
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "triggers", ["rule_id"], name: "index_triggers_on_rule_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                                      null: false
    t.string   "lastname",                                  null: false
    t.string   "email",                                     null: false
    t.string   "password_digest",                           null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "auth_token",                                null: false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.integer  "lock_version",           default: 0,        null: false
    t.string   "role",                   default: "author", null: false
    t.string   "username"
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["password_reset_token"], name: "index_users_on_password_reset_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

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

  add_foreign_key "comments", "issues", on_update: :restrict, on_delete: :restrict
  add_foreign_key "comments", "users", on_update: :restrict, on_delete: :restrict
  add_foreign_key "dependencies", "schedules", column: "dependent_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "dependencies", "schedules", on_update: :restrict, on_delete: :restrict
  add_foreign_key "descriptions", "scripts", on_update: :restrict, on_delete: :restrict
  add_foreign_key "dispatchers", "rules", on_update: :restrict, on_delete: :restrict
  add_foreign_key "dispatchers", "schedules", on_update: :restrict, on_delete: :restrict
  add_foreign_key "issues", "runs", on_update: :restrict, on_delete: :restrict
  add_foreign_key "jobs", "schedules", on_update: :restrict, on_delete: :restrict
  add_foreign_key "jobs", "scripts", on_update: :restrict, on_delete: :restrict
  add_foreign_key "jobs", "servers", on_update: :restrict, on_delete: :restrict
  add_foreign_key "outputs", "runs", on_update: :restrict, on_delete: :restrict
  add_foreign_key "outputs", "triggers", on_update: :restrict, on_delete: :restrict
  add_foreign_key "properties", "databases", on_update: :restrict, on_delete: :restrict
  add_foreign_key "requires", "scripts", column: "caller_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "requires", "scripts", on_update: :restrict, on_delete: :restrict
  add_foreign_key "runs", "jobs", on_update: :restrict, on_delete: :restrict
  add_foreign_key "subscriptions", "issues", on_update: :restrict, on_delete: :restrict
  add_foreign_key "subscriptions", "users", on_update: :restrict, on_delete: :restrict
  add_foreign_key "taggings", "tags", on_update: :restrict, on_delete: :restrict
  add_foreign_key "triggers", "rules", on_update: :restrict, on_delete: :restrict
end
