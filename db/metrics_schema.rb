# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_02_20_234259) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "series", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "timestamp", null: false
    t.string "identifier", null: false
    t.decimal "amount", precision: 15, scale: 3, null: false
    t.jsonb "data"
    t.index ["data"], name: "index_series_on_data", using: :gin
    t.index ["identifier"], name: "index_series_on_identifier"
    t.index ["name"], name: "index_series_on_name"
    t.index ["timestamp"], name: "index_series_on_timestamp"
  end

end
