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
    t.index ["preferences"], name: "index_profiles_on_preferences"
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
    t.jsonb "bank_account", default: {"bank"=>nil, "type"=>nil, "number"=>nil}
    t.jsonb "vehicles", default: {"vtv"=>{"uri"=>nil, "data"=>nil, "verified"=>false, "expiration_date"=>nil}, "brand"=>nil, "model"=>nil, "photo"=>nil, "patent"=>{"uri"=>nil, "data"=>nil, "verified"=>false, "expiration_date"=>nil}, "kit_security"=>{"uri"=>nil, "data"=>nil, "verified"=>false, "expiration_date"=>nil}, "vehicle_title"=>{"uri"=>nil, "data"=>nil, "verified"=>false, "expiration_date"=>nil}, "air_conditioner"=>{"uri"=>nil, "data"=>nil, "verified"=>false, "expiration_date"=>nil}, "insurance_thirds"=>{"uri"=>nil, "data"=>nil, "verified"=>false, "expiration_date"=>nil}, "free_traffic_ticket"=>{"uri"=>nil, "data"=>nil, "verified"=>false, "expiration_date"=>nil}, "habilitation_sticker"=>{"uri"=>nil, "data"=>nil, "verified"=>false, "expiration_date"=>nil}}
    t.string "gateway"
    t.string "gateway_id", null: false
    t.jsonb "data", default: {"comments"=>nil, "created_at_shippify"=>nil, "enabled_at_shippify"=>nil, "sent_email_instructions"=>false, "sent_email_invitation_shippify"=>false}
    t.jsonb "minimum_requirements", default: {"driving_license"=>{"uri"=>nil, "data"=>nil, "verified"=>false, "expiration_date"=>nil}, "has_cuit_or_cuil"=>false, "is_monotributista"=>{"uri"=>nil, "data"=>nil, "verified"=>false, "expiration_date"=>nil}, "has_paypal_account"=>false, "has_banking_account"=>false}
    t.jsonb "requirements", default: {"sanitary_notepad"=>{"uri"=>nil, "data"=>nil, "verified"=>false, "expiration_date"=>nil}, "habilitation_transport_food"=>{"uri"=>nil, "data"=>nil, "verified"=>false, "expiration_date"=>nil}}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_account"], name: "index_shippers_on_bank_account"
    t.index ["data"], name: "index_shippers_on_data"
    t.index ["minimum_requirements"], name: "index_shippers_on_minimum_requirements"
    t.index ["requirements"], name: "index_shippers_on_requirements"
    t.index ["vehicles"], name: "index_shippers_on_vehicles"
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
    t.index ["settings"], name: "index_users_on_settings"
    t.index ["username"], name: "index_users_on_username"
  end

end
