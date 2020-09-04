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

ActiveRecord::Schema.define(version: 2020_08_31_215058) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "emailtoken", null: false
    t.string "token", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "used", default: false
    t.index ["user_id"], name: "index_authentications_on_user_id"
  end

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

  create_table "questions", force: :cascade do |t|
    t.string "question"
    t.boolean "required_answer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "resource_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "time_limit", default: 60
    t.index ["resource_id"], name: "index_reservations_on_resource_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "resource_questions", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.bigint "resource_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_resource_questions_on_question_id"
    t.index ["resource_id"], name: "index_resource_questions_on_resource_id"
  end

  create_table "resources", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "time_limit", default: 60
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
    t.boolean "parking_admin"
  end

  add_foreign_key "authentications", "users"
  add_foreign_key "reservations", "resources"
  add_foreign_key "reservations", "users"
  add_foreign_key "resource_questions", "questions"
  add_foreign_key "resource_questions", "resources"
end
