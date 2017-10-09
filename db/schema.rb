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

ActiveRecord::Schema.define(version: 20170902003256) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text     "text",       null: false
    t.integer  "user_id",    null: false
    t.integer  "issue_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "file"
    t.index ["issue_id"], name: "index_comments_on_issue_id", using: :btree
    t.index ["text"], name: "index_comments_on_text", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "databases", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "driver",      null: false
    t.string   "description", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["name"], name: "index_databases_on_name", using: :btree
  end

  create_table "dependencies", force: :cascade do |t|
    t.integer  "dependent_id", null: false
    t.integer  "schedule_id",  null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["dependent_id"], name: "index_dependencies_on_dependent_id", using: :btree
    t.index ["schedule_id"], name: "index_dependencies_on_schedule_id", using: :btree
  end

  create_table "descriptions", force: :cascade do |t|
    t.string   "name",       null: false
    t.text     "value",      null: false
    t.integer  "script_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["script_id"], name: "index_descriptions_on_script_id", using: :btree
  end

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
    t.index ["rule_id"], name: "index_dispatchers_on_rule_id", using: :btree
    t.index ["schedule_id"], name: "index_dispatchers_on_schedule_id", using: :btree
  end

  create_table "issues", force: :cascade do |t|
    t.string   "status",                   null: false
    t.text     "description"
    t.jsonb    "data"
    t.integer  "run_id",                   null: false
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["created_at"], name: "index_issues_on_created_at", using: :btree
    t.index ["data"], name: "index_issues_on_data", using: :gin
    t.index ["description"], name: "index_issues_on_description", using: :btree
    t.index ["run_id"], name: "index_issues_on_run_id", using: :btree
    t.index ["status"], name: "index_issues_on_status", using: :btree
  end

  create_table "issues_permalinks", id: false, force: :cascade do |t|
    t.integer "issue_id",     null: false
    t.integer "permalink_id", null: false
    t.index ["issue_id"], name: "index_issues_permalinks_on_issue_id", using: :btree
    t.index ["permalink_id"], name: "index_issues_permalinks_on_permalink_id", using: :btree
  end

  create_table "jobs", force: :cascade do |t|
    t.integer  "schedule_id"
    t.integer  "server_id"
    t.integer  "script_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "hidden",      default: false, null: false
    t.index ["hidden"], name: "index_jobs_on_hidden", using: :btree
    t.index ["schedule_id"], name: "index_jobs_on_schedule_id", using: :btree
    t.index ["script_id"], name: "index_jobs_on_script_id", using: :btree
    t.index ["server_id"], name: "index_jobs_on_server_id", using: :btree
  end

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

  create_table "maintainers", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "script_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["script_id"], name: "index_maintainers_on_script_id", using: :btree
    t.index ["user_id"], name: "index_maintainers_on_user_id", using: :btree
  end

  create_table "outputs", force: :cascade do |t|
    t.text     "text"
    t.integer  "trigger_id", null: false
    t.integer  "run_id",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_outputs_on_created_at", using: :btree
    t.index ["run_id"], name: "index_outputs_on_run_id", using: :btree
    t.index ["trigger_id"], name: "index_outputs_on_trigger_id", using: :btree
  end

  create_table "parameters", force: :cascade do |t|
    t.string   "name",       null: false
    t.text     "value",      null: false
    t.integer  "script_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["script_id"], name: "index_parameters_on_script_id", using: :btree
  end

  create_table "permalinks", force: :cascade do |t|
    t.string   "token",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_permalinks_on_token", unique: true, using: :btree
  end

  create_table "properties", force: :cascade do |t|
    t.string   "key",         null: false
    t.string   "value",       null: false
    t.integer  "database_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["database_id"], name: "index_properties_on_database_id", using: :btree
  end

  create_table "requires", force: :cascade do |t|
    t.integer  "caller_id",  null: false
    t.integer  "script_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["caller_id"], name: "index_requires_on_caller_id", using: :btree
    t.index ["script_id"], name: "index_requires_on_script_id", using: :btree
  end

  create_table "rules", force: :cascade do |t|
    t.string   "name",                                                                                         null: false
    t.boolean  "enabled",      default: false,                                                                 null: false
    t.integer  "lock_version", default: 0,                                                                     null: false
    t.datetime "created_at",                                                                                   null: false
    t.datetime "updated_at",                                                                                   null: false
    t.uuid     "uuid",         default: -> { "(md5(((random())::text || (clock_timestamp())::text)))::uuid" }, null: false
    t.datetime "imported_at"
    t.index ["name"], name: "index_rules_on_name", using: :btree
    t.index ["uuid"], name: "index_rules_on_uuid", unique: true, using: :btree
  end

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
    t.index ["data"], name: "index_runs_on_data", using: :gin
    t.index ["job_id"], name: "index_runs_on_job_id", using: :btree
    t.index ["scheduled_at"], name: "index_runs_on_scheduled_at", using: :btree
    t.index ["status"], name: "index_runs_on_status", using: :btree
  end

  create_table "schedules", force: :cascade do |t|
    t.datetime "start",                        null: false
    t.datetime "end"
    t.integer  "interval"
    t.string   "frequency"
    t.integer  "lock_version", default: 0,     null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "name",                         null: false
    t.datetime "scheduled_at"
    t.boolean  "hidden",       default: false, null: false
    t.index ["frequency"], name: "index_schedules_on_frequency", using: :btree
    t.index ["hidden"], name: "index_schedules_on_hidden", using: :btree
    t.index ["interval"], name: "index_schedules_on_interval", using: :btree
    t.index ["name"], name: "index_schedules_on_name", using: :btree
    t.index ["scheduled_at"], name: "index_schedules_on_scheduled_at", using: :btree
  end

  create_table "scripts", force: :cascade do |t|
    t.string   "name",                                                                                         null: false
    t.string   "file"
    t.text     "text"
    t.integer  "lock_version", default: 0,                                                                     null: false
    t.datetime "created_at",                                                                                   null: false
    t.datetime "updated_at",                                                                                   null: false
    t.boolean  "core"
    t.string   "change"
    t.uuid     "uuid",         default: -> { "(md5(((random())::text || (clock_timestamp())::text)))::uuid" }
    t.datetime "imported_at"
    t.index ["core"], name: "index_scripts_on_core", using: :btree
    t.index ["name"], name: "index_scripts_on_name", using: :btree
    t.index ["uuid"], name: "index_scripts_on_uuid", unique: true, using: :btree
  end

  create_table "servers", force: :cascade do |t|
    t.string   "name",                     null: false
    t.string   "hostname",                 null: false
    t.string   "user"
    t.string   "password"
    t.string   "credential"
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["name"], name: "index_servers_on_name", using: :btree
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "issue_id",   null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_subscriptions_on_issue_id", using: :btree
    t.index ["user_id"], name: "index_subscriptions_on_user_id", using: :btree
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        null: false
    t.integer  "taggable_id",   null: false
    t.string   "taggable_type", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name",                             null: false
    t.integer  "lock_version", default: 0,         null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "kind",         default: "script",  null: false
    t.string   "style",        default: "default", null: false
    t.jsonb    "options"
    t.index ["kind"], name: "index_tags_on_kind", using: :btree
    t.index ["name"], name: "index_tags_on_name", using: :btree
    t.index ["options"], name: "index_tags_on_options", using: :gin
  end

  create_table "triggers", force: :cascade do |t|
    t.integer  "rule_id",                                                                                      null: false
    t.text     "callback",                                                                                     null: false
    t.integer  "lock_version", default: 0,                                                                     null: false
    t.datetime "created_at",                                                                                   null: false
    t.datetime "updated_at",                                                                                   null: false
    t.uuid     "uuid",         default: -> { "(md5(((random())::text || (clock_timestamp())::text)))::uuid" }, null: false
    t.index ["rule_id"], name: "index_triggers_on_rule_id", using: :btree
    t.index ["uuid"], name: "index_triggers_on_uuid", unique: true, using: :btree
  end

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
    t.boolean  "hidden",                 default: false,    null: false
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["hidden"], name: "index_users_on_hidden", using: :btree
    t.index ["password_reset_token"], name: "index_users_on_password_reset_token", unique: true, using: :btree
    t.index ["role"], name: "index_users_on_role", using: :btree
    t.index ["username"], name: "index_users_on_username", using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.integer  "whodunnit"
    t.jsonb    "object"
    t.jsonb    "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
    t.index ["whodunnit"], name: "index_versions_on_whodunnit", using: :btree
  end

  add_foreign_key "comments", "issues", on_update: :restrict, on_delete: :restrict
  add_foreign_key "comments", "users", on_update: :restrict, on_delete: :restrict
  add_foreign_key "dependencies", "schedules", column: "dependent_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "dependencies", "schedules", on_update: :restrict, on_delete: :restrict
  add_foreign_key "descriptions", "scripts", on_update: :restrict, on_delete: :restrict
  add_foreign_key "dispatchers", "rules", on_update: :restrict, on_delete: :restrict
  add_foreign_key "dispatchers", "schedules", on_update: :restrict, on_delete: :restrict
  add_foreign_key "issues", "runs", on_update: :restrict, on_delete: :restrict
  add_foreign_key "issues_permalinks", "issues", on_update: :restrict, on_delete: :restrict
  add_foreign_key "issues_permalinks", "permalinks", on_update: :restrict, on_delete: :restrict
  add_foreign_key "jobs", "schedules", on_update: :restrict, on_delete: :restrict
  add_foreign_key "jobs", "scripts", on_update: :restrict, on_delete: :restrict
  add_foreign_key "jobs", "servers", on_update: :restrict, on_delete: :restrict
  add_foreign_key "maintainers", "scripts", on_update: :restrict, on_delete: :restrict
  add_foreign_key "maintainers", "users", on_update: :restrict, on_delete: :restrict
  add_foreign_key "outputs", "runs", on_update: :restrict, on_delete: :restrict
  add_foreign_key "outputs", "triggers", on_update: :restrict, on_delete: :restrict
  add_foreign_key "parameters", "scripts", on_update: :restrict, on_delete: :restrict
  add_foreign_key "properties", "databases", on_update: :restrict, on_delete: :restrict
  add_foreign_key "requires", "scripts", column: "caller_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "requires", "scripts", on_update: :restrict, on_delete: :restrict
  add_foreign_key "runs", "jobs", on_update: :restrict, on_delete: :restrict
  add_foreign_key "subscriptions", "issues", on_update: :restrict, on_delete: :restrict
  add_foreign_key "subscriptions", "users", on_update: :restrict, on_delete: :restrict
  add_foreign_key "taggings", "tags", on_update: :restrict, on_delete: :restrict
  add_foreign_key "triggers", "rules", on_update: :restrict, on_delete: :restrict
end
