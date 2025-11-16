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

ActiveRecord::Schema[8.1].define(version: 2025_11_16_121133) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "approved_type", ["false", "true", "pending"]
  create_enum "user_type", ["tenant", "owner", "none"]

  create_table "authentications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "emailtoken", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.boolean "used", default: false
    t.bigint "user_id", null: false
    t.index ["emailtoken"], name: "index_authentications_on_emailtoken"
    t.index ["token"], name: "index_authentications_on_token"
    t.index ["user_id"], name: "index_authentications_on_user_id"
  end

  create_table "elevator_bookings", force: :cascade do |t|
    t.boolean "approved"
    t.datetime "created_at", null: false
    t.integer "deposit"
    t.datetime "end", precision: nil
    t.boolean "in"
    t.integer "moveType"
    t.string "name1"
    t.string "name2"
    t.boolean "out"
    t.string "phone_day"
    t.string "phone_night"
    t.text "rejection"
    t.datetime "start", precision: nil
    t.enum "status", default: "pending", enum_type: "approved_type"
    t.integer "unit"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_elevator_bookings_on_user_id"
  end

  create_table "parkings", force: :cascade do |t|
    t.string "code"
    t.string "color"
    t.string "contact"
    t.datetime "created_at", precision: nil, null: false
    t.date "end_date"
    t.string "license"
    t.string "make"
    t.date "start_date"
    t.integer "unit"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "questions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "question"
    t.boolean "required_answer"
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.timestamptz "end_time"
    t.bigint "resource_id", null: false
    t.timestamptz "start_time"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["resource_id"], name: "index_reservations_on_resource_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "resource_questions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "question_id", null: false
    t.bigint "resource_id", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_resource_questions_on_question_id"
    t.index ["resource_id"], name: "index_resource_questions_on_resource_id"
  end

  create_table "resources", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "time_limit", default: 60
    t.datetime "updated_at", null: false
    t.boolean "vaccine", default: false
    t.boolean "visible", default: true
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.boolean "parking_admin"
    t.string "phone"
    t.enum "resident_type", default: "none", enum_type: "user_type"
    t.integer "unit"
    t.datetime "updated_at", null: false
    t.boolean "vaccinated", default: false
  end

  create_table "webauthn_credentials", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "credential_type", default: "passkey"
    t.string "external_id", null: false
    t.datetime "last_used_at"
    t.string "nickname"
    t.text "public_key", null: false
    t.bigint "sign_count", default: 0, null: false
    t.text "transports"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["external_id"], name: "index_webauthn_credentials_on_external_id", unique: true
    t.index ["user_id"], name: "index_webauthn_credentials_on_user_id"
  end

  add_foreign_key "authentications", "users"
  add_foreign_key "elevator_bookings", "users"
  add_foreign_key "reservations", "resources"
  add_foreign_key "reservations", "users"
  add_foreign_key "resource_questions", "questions"
  add_foreign_key "resource_questions", "resources"
  add_foreign_key "webauthn_credentials", "users"
end
