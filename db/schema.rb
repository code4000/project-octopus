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

ActiveRecord::Schema.define(version: 2019_05_09_125635) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "persons", force: :cascade do |t|
    t.integer "type", null: false
    t.bigint "site_id"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.integer "gender", null: false
    t.date "dob", null: false
    t.date "crd"
    t.date "hdc"
    t.date "rotl"
    t.date "recat"
    t.text "address"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_persons_on_site_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string "name", null: false
    t.integer "capacity"
    t.text "address"
    t.string "manager"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "persons", "sites"
end
