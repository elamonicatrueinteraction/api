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

ActiveRecord::Schema.define(version: 20171031163630) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pgcrypto"

  create_table "profiles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.uuid "user_id", null: false
    t.jsonb "preferences", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["preferences"], name: "index_profiles_on_preferences", using: :gin
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "shippers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "gender"
    t.date "birth_date"
    t.string "email", null: false
    t.string "phone_num"
    t.string "photo"
    t.string "cuit"
    t.string "cuil"
    t.boolean "verified", default: false
    t.date "verified_at"
    t.jsonb "bank_account", default: {}
    t.jsonb "vehicles", default: {}
    t.string "gateway"
    t.string "gateway_id", null: false
    t.jsonb "data", default: {}
    t.jsonb "minimum_requirements", default: {}
    t.jsonb "requirements", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_account"], name: "index_shippers_on_bank_account", using: :gin
    t.index ["data"], name: "index_shippers_on_data", using: :gin
    t.index ["minimum_requirements"], name: "index_shippers_on_minimum_requirements", using: :gin
    t.index ["requirements"], name: "index_shippers_on_requirements", using: :gin
    t.index ["vehicles"], name: "index_shippers_on_vehicles", using: :gin
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.integer "token_expire_at"
    t.integer "login_count", default: 0, null: false
    t.integer "failed_login_count", default: 0, null: false
    t.datetime "last_login_at"
    t.string "last_login_ip"
    t.boolean "active", default: false
    t.boolean "confirmed", default: false
    t.integer "roles_mask"
    t.jsonb "settings", default: {}, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["roles_mask"], name: "index_users_on_roles_mask"
    t.index ["settings"], name: "index_users_on_settings", using: :gin
    t.index ["username"], name: "index_users_on_username"
  end

end
