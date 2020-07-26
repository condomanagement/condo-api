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

ActiveRecord::Schema.define(version: 2020_07_25_125938) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "parkings", force: :cascade do |t|
    t.string "code"
    t.integer "unit"
    t.string "make"
    t.string "color"
    t.string "license"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "start_date"
    t.date "end_date"
    t.string "contact"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "unit"
    t.string "email"
    t.string "phone"
    t.boolean "active"
    t.boolean "admin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
