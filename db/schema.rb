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

  create_table "comments", id: :serial, force: :cascade do |t|
    t.text "text", null: false
    t.integer "user_id", null: false
    t.integer "issue_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file"
    t.index ["issue_id"], name: "index_comments_on_issue_id"
    t.index ["text"], name: "index_comments_on_text"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "databases", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "driver", null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_databases_on_name"
  end

  create_table "dependencies", id: :serial, force: :cascade do |t|
    t.integer "dependent_id", null: false
    t.integer "schedule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dependent_id"], name: "index_dependencies_on_dependent_id"
    t.index ["schedule_id"], name: "index_dependencies_on_schedule_id"
  end

  create_table "descriptions", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "value", null: false
    t.integer "script_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["script_id"], name: "index_descriptions_on_script_id"
  end

  create_table "descriptors", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dispatchers", id: :serial, force: :cascade do |t|
    t.integer "schedule_id"
    t.integer "rule_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rule_id"], name: "index_dispatchers_on_rule_id"
    t.index ["schedule_id"], name: "index_dispatchers_on_schedule_id"
  end

  create_table "issues", id: :serial, force: :cascade do |t|
    t.string "status", null: false
    t.text "description"
    t.jsonb "data"
    t.integer "run_id", null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_issues_on_created_at"
    t.index ["data"], name: "index_issues_on_data", using: :gin
    t.index ["description"], name: "index_issues_on_description"
    t.index ["run_id"], name: "index_issues_on_run_id"
    t.index ["status"], name: "index_issues_on_status"
  end

  create_table "issues_permalinks", id: false, force: :cascade do |t|
    t.bigint "issue_id", null: false
    t.bigint "permalink_id", null: false
    t.index ["issue_id"], name: "index_issues_permalinks_on_issue_id"
    t.index ["permalink_id"], name: "index_issues_permalinks_on_permalink_id"
  end

  create_table "jobs", id: :serial, force: :cascade do |t|
    t.integer "schedule_id"
    t.integer "server_id"
    t.integer "script_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hidden", default: false, null: false
    t.index ["hidden"], name: "index_jobs_on_hidden"
    t.index ["schedule_id"], name: "index_jobs_on_schedule_id"
    t.index ["script_id"], name: "index_jobs_on_script_id"
    t.index ["server_id"], name: "index_jobs_on_server_id"
  end

  create_table "ldaps", id: :serial, force: :cascade do |t|
    t.string "hostname", null: false
    t.integer "port", default: 389, null: false
    t.string "basedn", null: false
    t.string "filter"
    t.string "login_mask", null: false
    t.string "username_attribute", null: false
    t.string "name_attribute", null: false
    t.string "lastname_attribute", null: false
    t.string "email_attribute", null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "options"
    t.string "roles_attribute", null: false
  end

  create_table "maintainers", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "script_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["script_id"], name: "index_maintainers_on_script_id"
    t.index ["user_id"], name: "index_maintainers_on_user_id"
  end

  create_table "outputs", id: :serial, force: :cascade do |t|
    t.text "text"
    t.integer "trigger_id", null: false
    t.integer "run_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_outputs_on_created_at"
    t.index ["run_id"], name: "index_outputs_on_run_id"
    t.index ["trigger_id"], name: "index_outputs_on_trigger_id"
  end

  create_table "parameters", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "value", null: false
    t.integer "script_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["script_id"], name: "index_parameters_on_script_id"
  end

  create_table "permalinks", id: :serial, force: :cascade do |t|
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_permalinks_on_token", unique: true
  end

  create_table "properties", id: :serial, force: :cascade do |t|
    t.string "key", null: false
    t.string "value", null: false
    t.integer "database_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["database_id"], name: "index_properties_on_database_id"
  end

  create_table "requires", id: :serial, force: :cascade do |t|
    t.integer "caller_id", null: false
    t.integer "script_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["caller_id"], name: "index_requires_on_caller_id"
    t.index ["script_id"], name: "index_requires_on_script_id"
  end

  create_table "rules", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.boolean "enabled", default: false, null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "(md5(((random())::text || (clock_timestamp())::text)))::uuid" }, null: false
    t.datetime "imported_at"
    t.index ["name"], name: "index_rules_on_name"
    t.index ["uuid"], name: "index_rules_on_uuid", unique: true
  end

  create_table "runs", id: :serial, force: :cascade do |t|
    t.string "status", null: false
    t.datetime "scheduled_at", null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.text "output"
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "job_id"
    t.jsonb "data"
    t.index ["data"], name: "index_runs_on_data", using: :gin
    t.index ["job_id"], name: "index_runs_on_job_id"
    t.index ["scheduled_at"], name: "index_runs_on_scheduled_at"
    t.index ["status"], name: "index_runs_on_status"
  end

  create_table "schedules", id: :serial, force: :cascade do |t|
    t.datetime "start", null: false
    t.datetime "end"
    t.integer "interval"
    t.string "frequency"
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.datetime "scheduled_at"
    t.boolean "hidden", default: false, null: false
    t.index ["frequency"], name: "index_schedules_on_frequency"
    t.index ["hidden"], name: "index_schedules_on_hidden"
    t.index ["interval"], name: "index_schedules_on_interval"
    t.index ["name"], name: "index_schedules_on_name"
    t.index ["scheduled_at"], name: "index_schedules_on_scheduled_at"
  end

  create_table "scripts", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "file"
    t.text "text"
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "core"
    t.string "change"
    t.uuid "uuid", default: -> { "(md5(((random())::text || (clock_timestamp())::text)))::uuid" }, null: false
    t.datetime "imported_at"
    t.index ["core"], name: "index_scripts_on_core"
    t.index ["name"], name: "index_scripts_on_name"
    t.index ["uuid"], name: "index_scripts_on_uuid", unique: true
  end

  create_table "servers", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "hostname", null: false
    t.string "user"
    t.string "password"
    t.string "credential"
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_servers_on_name"
  end

  create_table "sessions", id: :serial, force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "subscriptions", id: :serial, force: :cascade do |t|
    t.integer "issue_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_subscriptions_on_issue_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id", null: false
    t.string "taggable_type", null: false
    t.integer "taggable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "kind", default: "script", null: false
    t.string "style", default: "default", null: false
    t.jsonb "options"
    t.index ["kind"], name: "index_tags_on_kind"
    t.index ["name"], name: "index_tags_on_name"
    t.index ["options"], name: "index_tags_on_options", using: :gin
  end

  create_table "triggers", id: :serial, force: :cascade do |t|
    t.integer "rule_id", null: false
    t.text "callback", null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "(md5(((random())::text || (clock_timestamp())::text)))::uuid" }, null: false
    t.index ["rule_id"], name: "index_triggers_on_rule_id"
    t.index ["uuid"], name: "index_triggers_on_uuid", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "lastname", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_token", null: false
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.integer "lock_version", default: 0, null: false
    t.string "role", default: "author", null: false
    t.string "username"
    t.boolean "hidden", default: false, null: false
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["hidden"], name: "index_users_on_hidden"
    t.index ["password_reset_token"], name: "index_users_on_password_reset_token", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["username"], name: "index_users_on_username"
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.integer "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["whodunnit"], name: "index_versions_on_whodunnit"
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
