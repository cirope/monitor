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

ActiveRecord::Schema.define(version: 20150601222419) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ldaps", force: true do |t|
    t.string   "hostname",                         null: false
    t.integer  "port",               default: 389, null: false
    t.string   "basedn",                           null: false
    t.string   "filter"
    t.string   "login_mask",                       null: false
    t.string   "username_attribute",               null: false
    t.string   "name_attribute",                   null: false
    t.string   "lastname_attribute",               null: false
    t.string   "email_attribute",                  null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "users", force: true do |t|
    t.string   "name",                   limit: nil,             null: false
    t.string   "lastname",               limit: nil,             null: false
    t.string   "email",                  limit: nil,             null: false
    t.string   "password_digest",        limit: nil,             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token",             limit: nil,             null: false
    t.string   "password_reset_token",   limit: nil
    t.datetime "password_reset_sent_at"
    t.integer  "lock_version",                       default: 0, null: false
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["password_reset_token"], name: "index_users_on_password_reset_token", unique: true, using: :btree

end
