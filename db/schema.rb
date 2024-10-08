# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_09_16_173214) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.string "tenant_name", limit: 63, null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.jsonb "options"
    t.string "style", default: "default", null: false
    t.index ["name"], name: "index_accounts_on_name"
    t.index ["tenant_name"], name: "index_accounts_on_tenant_name", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.text "text", null: false
    t.integer "user_id", null: false
    t.integer "issue_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "file"
    t.index ["issue_id"], name: "index_comments_on_issue_id"
    t.index ["text"], name: "index_comments_on_text"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "databases", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "driver", null: false
    t.string "description", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "account_id"
    t.index ["account_id"], name: "index_databases_on_account_id"
    t.index ["name"], name: "index_databases_on_name"
  end

  create_table "dependencies", id: :serial, force: :cascade do |t|
    t.integer "dependent_id", null: false
    t.integer "schedule_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["dependent_id"], name: "index_dependencies_on_dependent_id"
    t.index ["schedule_id"], name: "index_dependencies_on_schedule_id"
  end

  create_table "descriptions", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "value", null: false
    t.integer "script_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "public", default: false, null: false
    t.index ["public"], name: "index_descriptions_on_public"
    t.index ["script_id"], name: "index_descriptions_on_script_id"
  end

  create_table "descriptors", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "public", default: false, null: false
  end

  create_table "dispatchers", id: :serial, force: :cascade do |t|
    t.integer "schedule_id"
    t.integer "rule_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["rule_id"], name: "index_dispatchers_on_rule_id"
    t.index ["schedule_id"], name: "index_dispatchers_on_schedule_id"
  end

  create_table "drives", force: :cascade do |t|
    t.string "name", null: false
    t.string "provider", null: false
    t.string "client_id", null: false
    t.string "client_secret", null: false
    t.string "identifier", null: false
    t.bigint "account_id", null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "options"
    t.index ["account_id"], name: "index_drives_on_account_id"
    t.index ["identifier"], name: "index_drives_on_identifier"
    t.index ["name"], name: "index_drives_on_name", unique: true
  end

  create_table "effects", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "implied_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["implied_id"], name: "index_effects_on_implied_id"
    t.index ["tag_id"], name: "index_effects_on_tag_id"
  end

  create_table "executions", force: :cascade do |t|
    t.bigint "script_id", null: false
    t.bigint "server_id", null: false
    t.string "status", default: "pending"
    t.datetime "started_at", precision: nil
    t.datetime "ended_at", precision: nil
    t.text "stdout"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "pid"
    t.text "stderr"
    t.index ["script_id"], name: "index_executions_on_script_id"
    t.index ["server_id"], name: "index_executions_on_server_id"
    t.index ["started_at"], name: "index_executions_on_started_at"
    t.index ["user_id"], name: "index_executions_on_user_id"
  end

  create_table "fails", force: :cascade do |t|
    t.jsonb "data"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["created_at"], name: "index_fails_on_created_at"
    t.index ["user_id"], name: "index_fails_on_user_id"
  end

  create_table "issues", id: :serial, force: :cascade do |t|
    t.string "status", null: false
    t.text "description"
    t.jsonb "data"
    t.integer "owner_id"
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "data_type"
    t.jsonb "options"
    t.jsonb "state_transitions", default: {}
    t.text "canonical_data"
    t.string "owner_type"
    t.string "title"
    t.index ["canonical_data"], name: "index_issues_on_canonical_data", opclass: :gin_trgm_ops, using: :gin
    t.index ["created_at"], name: "index_issues_on_created_at"
    t.index ["data"], name: "index_issues_on_data", using: :gin
    t.index ["description"], name: "index_issues_on_description"
    t.index ["options"], name: "index_issues_on_options", using: :gin
    t.index ["owner_type", "owner_id"], name: "index_issues_on_owner"
    t.index ["status"], name: "index_issues_on_status"
  end

  create_table "issues_permalinks", id: false, force: :cascade do |t|
    t.integer "issue_id", null: false
    t.integer "permalink_id", null: false
    t.index ["issue_id"], name: "index_issues_permalinks_on_issue_id"
    t.index ["permalink_id"], name: "index_issues_permalinks_on_permalink_id"
  end

  create_table "jobs", id: :serial, force: :cascade do |t|
    t.integer "schedule_id"
    t.integer "server_id"
    t.integer "script_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.text "filter"
    t.string "login_mask", null: false
    t.string "username_attribute", null: false
    t.string "name_attribute", null: false
    t.string "lastname_attribute", null: false
    t.string "email_attribute", null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.jsonb "options"
    t.string "roles_attribute", null: false
  end

  create_table "libraries", force: :cascade do |t|
    t.string "name", null: false
    t.string "options"
    t.bigint "script_id", null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["script_id"], name: "index_libraries_on_script_id"
  end

  create_table "logins", force: :cascade do |t|
    t.jsonb "data"
    t.datetime "closed_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.bigint "user_id", null: false
    t.index ["created_at"], name: "index_logins_on_created_at"
    t.index ["user_id"], name: "index_logins_on_user_id"
  end

  create_table "maintainers", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "script_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["script_id"], name: "index_maintainers_on_script_id"
    t.index ["user_id"], name: "index_maintainers_on_user_id"
  end

  create_table "measures", force: :cascade do |t|
    t.string "measurable_type", null: false
    t.bigint "measurable_id", null: false
    t.decimal "cpu", precision: 5, scale: 1, null: false
    t.bigint "memory_in_bytes", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["created_at"], name: "index_measures_on_created_at"
    t.index ["measurable_type", "measurable_id"], name: "index_measures_on_measurable_type_and_measurable_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "email", null: false
    t.string "username"
    t.boolean "default", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["account_id", "email"], name: "index_memberships_on_account_id_and_email", unique: true
    t.index ["account_id"], name: "index_memberships_on_account_id"
    t.index ["email"], name: "index_memberships_on_email"
    t.index ["username"], name: "index_memberships_on_username"
  end

  create_table "outputs", id: :serial, force: :cascade do |t|
    t.text "text"
    t.integer "trigger_id", null: false
    t.integer "run_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["created_at"], name: "index_outputs_on_created_at"
    t.index ["run_id"], name: "index_outputs_on_run_id"
    t.index ["trigger_id"], name: "index_outputs_on_trigger_id"
  end

  create_table "parameters", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "value", null: false
    t.integer "script_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["script_id"], name: "index_parameters_on_script_id"
  end

  create_table "pdf_templates", force: :cascade do |t|
    t.string "name", null: false
    t.text "content"
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permalinks", id: :serial, force: :cascade do |t|
    t.string "token", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["token"], name: "index_permalinks_on_token", unique: true
  end

  create_table "permissions", force: :cascade do |t|
    t.string "section", null: false
    t.boolean "read", default: false, null: false
    t.boolean "edit", default: false, null: false
    t.boolean "remove", default: false, null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_permissions_on_role_id"
    t.index ["section"], name: "index_permissions_on_section"
  end

  create_table "properties", id: :serial, force: :cascade do |t|
    t.string "key", null: false
    t.string "value", null: false
    t.integer "database_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["database_id"], name: "index_properties_on_database_id"
  end

  create_table "reminders", force: :cascade do |t|
    t.datetime "due_at", precision: nil, null: false
    t.string "state_class_type", null: false
    t.jsonb "transition_rules"
    t.bigint "issue_id", null: false
    t.index ["due_at"], name: "index_reminders_on_due_at"
    t.index ["issue_id"], name: "index_reminders_on_issue_id"
    t.index ["state_class_type"], name: "index_reminders_on_state_class_type"
  end

  create_table "requires", id: :serial, force: :cascade do |t|
    t.integer "caller_id", null: false
    t.integer "script_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["caller_id"], name: "index_requires_on_caller_id"
    t.index ["script_id"], name: "index_requires_on_script_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "type", null: false
    t.string "name", null: false
    t.string "description", null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "identifier"
    t.index ["identifier"], name: "index_roles_on_identifier", unique: true
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "rules", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.boolean "enabled", default: false, null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.uuid "uuid", default: -> { "(md5(((random())::text || (clock_timestamp())::text)))::uuid" }, null: false
    t.datetime "imported_at", precision: nil
    t.index ["name"], name: "index_rules_on_name"
    t.index ["uuid"], name: "index_rules_on_uuid", unique: true
  end

  create_table "runs", id: :serial, force: :cascade do |t|
    t.string "status", null: false
    t.datetime "scheduled_at", precision: nil, null: false
    t.datetime "started_at", precision: nil
    t.datetime "ended_at", precision: nil
    t.text "stdout"
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "job_id"
    t.jsonb "data"
    t.integer "pid"
    t.text "stderr"
    t.bigint "script_id"
    t.bigint "server_id"
    t.index ["data"], name: "index_runs_on_data", using: :gin
    t.index ["job_id"], name: "index_runs_on_job_id"
    t.index ["scheduled_at"], name: "index_runs_on_scheduled_at"
    t.index ["script_id"], name: "index_runs_on_script_id"
    t.index ["server_id"], name: "index_runs_on_server_id"
    t.index ["status"], name: "index_runs_on_status"
  end

  create_table "samls", force: :cascade do |t|
    t.string "provider", null: false
    t.string "idp_homepage", null: false
    t.string "idp_entity_id", null: false
    t.string "idp_sso_target_url", null: false
    t.string "sp_entity_id", null: false
    t.string "assertion_consumer_service_url", null: false
    t.string "name_identifier_format", null: false
    t.string "assertion_consumer_service_binding", null: false
    t.text "idp_cert", null: false
    t.string "username_attribute", null: false
    t.string "name_attribute", null: false
    t.string "lastname_attribute", null: false
    t.string "email_attribute", null: false
    t.string "roles_attribute", null: false
    t.jsonb "options"
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedules", id: :serial, force: :cascade do |t|
    t.datetime "start", precision: nil, null: false
    t.datetime "end", precision: nil
    t.integer "interval"
    t.string "frequency"
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "name", null: false
    t.datetime "scheduled_at", precision: nil
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "core"
    t.string "change"
    t.uuid "uuid", default: -> { "(md5(((random())::text || (clock_timestamp())::text)))::uuid" }, null: false
    t.datetime "imported_at", precision: nil
    t.string "language", default: "ruby"
    t.bigint "database_id"
    t.string "imported_as"
    t.jsonb "status"
    t.index ["core"], name: "index_scripts_on_core"
    t.index ["database_id"], name: "index_scripts_on_database_id"
    t.index ["name"], name: "index_scripts_on_name"
    t.index ["status"], name: "index_scripts_on_status", using: :gin
    t.index ["text"], name: "index_scripts_on_text", opclass: :gin_trgm_ops, using: :gin
    t.index ["uuid"], name: "index_scripts_on_uuid", unique: true
  end

  create_table "series", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "timestamp", precision: nil, null: false
    t.string "identifier", null: false
    t.decimal "amount", precision: 15, scale: 3, null: false
    t.jsonb "data"
    t.index ["data"], name: "index_series_on_data", using: :gin
    t.index ["identifier"], name: "index_series_on_identifier"
    t.index ["name"], name: "index_series_on_name"
    t.index ["timestamp"], name: "index_series_on_timestamp"
  end

  create_table "servers", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "hostname", null: false
    t.string "user"
    t.string "password"
    t.string "credential"
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "default", default: false, null: false
    t.index ["default"], name: "index_servers_on_default"
    t.index ["name"], name: "index_servers_on_name"
  end

  create_table "sessions", id: :serial, force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "subscriptions", id: :serial, force: :cascade do |t|
    t.integer "issue_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["issue_id"], name: "index_subscriptions_on_issue_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id", null: false
    t.string "taggable_type", null: false
    t.integer "taggable_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "kind", default: "script", null: false
    t.string "style", default: "secondary", null: false
    t.jsonb "options"
    t.bigint "parent_id"
    t.index ["kind"], name: "index_tags_on_kind"
    t.index ["name"], name: "index_tags_on_name"
    t.index ["options"], name: "index_tags_on_options", using: :gin
    t.index ["parent_id"], name: "index_tags_on_parent_id"
  end

  create_table "triggers", id: :serial, force: :cascade do |t|
    t.integer "rule_id", null: false
    t.text "callback", null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.uuid "uuid", default: -> { "(md5(((random())::text || (clock_timestamp())::text)))::uuid" }, null: false
    t.index ["rule_id"], name: "index_triggers_on_rule_id"
    t.index ["uuid"], name: "index_triggers_on_uuid", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "lastname", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "auth_token", null: false
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at", precision: nil
    t.integer "lock_version", default: 0, null: false
    t.string "old_role"
    t.string "username"
    t.boolean "hidden", default: false, null: false
    t.string "saml_request_id"
    t.bigint "role_id"
    t.jsonb "data"
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["hidden"], name: "index_users_on_hidden"
    t.index ["old_role"], name: "index_users_on_old_role"
    t.index ["password_reset_token"], name: "index_users_on_password_reset_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["saml_request_id"], name: "index_users_on_saml_request_id"
    t.index ["username"], name: "index_users_on_username"
  end

  create_table "variables", force: :cascade do |t|
    t.string "name", null: false
    t.string "value", null: false
    t.bigint "script_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["script_id"], name: "index_variables_on_script_id"
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.integer "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["whodunnit"], name: "index_versions_on_whodunnit"
  end

  create_table "views", force: :cascade do |t|
    t.bigint "issue_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_views_on_issue_id"
    t.index ["user_id"], name: "index_views_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "issues", on_update: :restrict, on_delete: :restrict
  add_foreign_key "comments", "users", on_update: :restrict, on_delete: :restrict
  add_foreign_key "databases", "accounts", on_update: :restrict, on_delete: :restrict
  add_foreign_key "dependencies", "schedules", column: "dependent_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "dependencies", "schedules", on_update: :restrict, on_delete: :restrict
  add_foreign_key "descriptions", "scripts", on_update: :restrict, on_delete: :restrict
  add_foreign_key "dispatchers", "rules", on_update: :restrict, on_delete: :restrict
  add_foreign_key "dispatchers", "schedules", on_update: :restrict, on_delete: :restrict
  add_foreign_key "drives", "accounts", on_update: :restrict, on_delete: :restrict
  add_foreign_key "effects", "tags", column: "implied_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "effects", "tags", on_update: :restrict, on_delete: :restrict
  add_foreign_key "fails", "users", on_update: :restrict, on_delete: :restrict
  add_foreign_key "issues_permalinks", "issues", on_update: :restrict, on_delete: :restrict
  add_foreign_key "issues_permalinks", "permalinks", on_update: :restrict, on_delete: :restrict
  add_foreign_key "jobs", "schedules", on_update: :restrict, on_delete: :restrict
  add_foreign_key "jobs", "scripts", on_update: :restrict, on_delete: :restrict
  add_foreign_key "jobs", "servers", on_update: :restrict, on_delete: :restrict
  add_foreign_key "libraries", "scripts", on_update: :restrict, on_delete: :restrict
  add_foreign_key "logins", "users", on_update: :restrict, on_delete: :restrict
  add_foreign_key "maintainers", "scripts", on_update: :restrict, on_delete: :restrict
  add_foreign_key "maintainers", "users", on_update: :restrict, on_delete: :restrict
  add_foreign_key "memberships", "accounts", on_update: :restrict, on_delete: :restrict
  add_foreign_key "outputs", "runs", on_update: :restrict, on_delete: :restrict
  add_foreign_key "outputs", "triggers", on_update: :restrict, on_delete: :restrict
  add_foreign_key "parameters", "scripts", on_update: :restrict, on_delete: :restrict
  add_foreign_key "permissions", "roles", on_update: :restrict, on_delete: :restrict
  add_foreign_key "properties", "databases", on_update: :restrict, on_delete: :restrict
  add_foreign_key "reminders", "issues", on_update: :restrict, on_delete: :restrict
  add_foreign_key "requires", "scripts", column: "caller_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "requires", "scripts", on_update: :restrict, on_delete: :restrict
  add_foreign_key "runs", "jobs", on_update: :restrict, on_delete: :restrict
  add_foreign_key "runs", "scripts", on_update: :restrict, on_delete: :restrict
  add_foreign_key "runs", "servers", on_update: :restrict, on_delete: :restrict
  add_foreign_key "subscriptions", "issues", on_update: :restrict, on_delete: :restrict
  add_foreign_key "subscriptions", "users", on_update: :restrict, on_delete: :restrict
  add_foreign_key "taggings", "tags", on_update: :restrict, on_delete: :restrict
  add_foreign_key "tags", "tags", column: "parent_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "triggers", "rules", on_update: :restrict, on_delete: :restrict
  add_foreign_key "users", "roles", on_update: :restrict, on_delete: :restrict
  add_foreign_key "variables", "scripts", on_update: :restrict, on_delete: :restrict
  add_foreign_key "views", "issues", on_update: :restrict, on_delete: :restrict
  add_foreign_key "views", "users", on_update: :restrict, on_delete: :restrict
end
