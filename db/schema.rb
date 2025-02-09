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

ActiveRecord::Schema.define(version: 20200129203856) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "pgcrypto"

  create_table "account_balances", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "institution_id"
    t.decimal "amount", precision: 12, scale: 4, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["institution_id"], name: "index_account_balances_on_institution_id", unique: true
  end

  create_table "addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "institution_id"
    t.geography "gps_coordinates", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.string "street_1"
    t.string "street_2"
    t.string "zip_code"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "contact_name"
    t.string "contact_cellphone"
    t.string "contact_email"
    t.string "telephone"
    t.string "open_hours"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "lookup"
    t.string "gateway"
    t.string "gateway_id"
    t.jsonb "gateway_data", default: {}
    t.index ["gateway_data"], name: "index_addresses_on_gateway_data", using: :gin
    t.index ["gps_coordinates"], name: "index_addresses_on_gps_coordinates", using: :gist
    t.index ["institution_id"], name: "index_addresses_on_institution_id"
  end

  create_table "audits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "audited_id"
    t.string "audited_type"
    t.string "message"
    t.string "field"
    t.string "original_value"
    t.string "new_value"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["audited_id", "audited_type"], name: "index_audits_on_audited_id_and_audited_type"
  end

  create_table "bank_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "bank_name"
    t.string "number"
    t.string "type"
    t.string "cbu"
    t.uuid "shipper_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "network_id"
    t.index ["network_id"], name: "index_bank_accounts_on_network_id"
    t.index ["shipper_id"], name: "index_bank_accounts_on_shipper_id"
  end

  create_table "deliveries", force: :cascade do |t|
    t.uuid "order_id"
    t.uuid "trip_id"
    t.decimal "amount", precision: 12, scale: 4, default: "0.0"
    t.decimal "bonified_amount", precision: 12, scale: 4, default: "0.0"
    t.uuid "origin_id"
    t.geography "origin_gps_coordinates", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.uuid "destination_id"
    t.geography "destination_gps_coordinates", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gateway"
    t.string "gateway_id"
    t.jsonb "gateway_data", default: {}
    t.jsonb "pickup", default: {}
    t.jsonb "dropoff", default: {}
    t.jsonb "extras", default: {}
    t.index ["destination_gps_coordinates"], name: "index_deliveries_on_destination_gps_coordinates", using: :gist
    t.index ["destination_id"], name: "index_deliveries_on_destination_id"
    t.index ["dropoff"], name: "index_deliveries_on_dropoff", using: :gin
    t.index ["extras"], name: "index_deliveries_on_extras", using: :gin
    t.index ["gateway_data"], name: "index_deliveries_on_gateway_data", using: :gin
    t.index ["order_id"], name: "index_deliveries_on_order_id"
    t.index ["origin_gps_coordinates"], name: "index_deliveries_on_origin_gps_coordinates", using: :gist
    t.index ["origin_id"], name: "index_deliveries_on_origin_id"
    t.index ["pickup"], name: "index_deliveries_on_pickup", using: :gin
    t.index ["trip_id"], name: "index_deliveries_on_trip_id"
  end

  create_table "districts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "institutions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "legal_name"
    t.string "uid_type"
    t.string "uid"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "district_id"
    t.integer "beneficiaries"
    t.string "offered_services", default: [], array: true
    t.index ["district_id"], name: "index_institutions_on_district_id"
  end

  create_table "job_results", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "result"
    t.string "message"
    t.jsonb "extra_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "milestones", force: :cascade do |t|
    t.uuid "trip_id"
    t.string "name"
    t.text "comments"
    t.jsonb "data", default: {}
    t.geography "gps_coordinates", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.datetime "created_at"
    t.string "network_id"
    t.index ["data"], name: "index_milestones_on_data", using: :gin
    t.index ["gps_coordinates"], name: "index_milestones_on_gps_coordinates", using: :gist
    t.index ["network_id"], name: "index_milestones_on_network_id"
    t.index ["trip_id"], name: "index_milestones_on_trip_id"
  end

  create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "giver_id"
    t.uuid "receiver_id"
    t.date "expiration"
    t.decimal "amount", precision: 12, scale: 4, default: "0.0"
    t.decimal "bonified_amount", precision: 12, scale: 4, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "extras", default: {}
    t.string "network_id"
    t.boolean "with_delivery"
    t.index ["extras"], name: "index_orders_on_extras", using: :gin
    t.index ["giver_id"], name: "index_orders_on_giver_id"
    t.index ["network_id"], name: "index_orders_on_network_id"
    t.index ["receiver_id"], name: "index_orders_on_receiver_id"
  end

  create_table "packages", force: :cascade do |t|
    t.integer "delivery_id"
    t.integer "weight"
    t.integer "volume"
    t.boolean "cooling", default: false
    t.text "description"
    t.uuid "attachment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity", default: 1
    t.boolean "fragile", default: false
    t.string "network_id"
    t.index ["attachment_id"], name: "index_packages_on_attachment_id"
    t.index ["delivery_id"], name: "index_packages_on_delivery_id"
    t.index ["network_id"], name: "index_packages_on_network_id"
  end

  create_table "payments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "status"
    t.decimal "amount", precision: 10, scale: 2
    t.decimal "collected_amount", precision: 10, scale: 2
    t.string "payable_type"
    t.string "payable_id"
    t.string "gateway"
    t.string "gateway_id"
    t.jsonb "gateway_data", default: {}
    t.jsonb "notifications"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "network_id"
    t.string "comment", default: ""
    t.datetime "paid_at"
    t.index ["gateway", "gateway_id"], name: "index_payments_on_gateway_and_gateway_id"
    t.index ["gateway_data"], name: "index_payments_on_gateway_data", using: :gin
    t.index ["network_id"], name: "index_payments_on_network_id"
    t.index ["notifications"], name: "index_payments_on_notifications", using: :gin
    t.index ["payable_type", "payable_id"], name: "index_payments_on_payable_type_and_payable_id"
  end

  create_table "profiles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.uuid "user_id", null: false
    t.jsonb "extras", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["extras"], name: "index_profiles_on_extras", using: :gin
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "shippers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name"
    t.string "gender"
    t.date "birth_date"
    t.string "email", null: false
    t.string "phone_num"
    t.string "photo"
    t.boolean "active", default: false
    t.boolean "verified", default: false
    t.date "verified_at"
    t.jsonb "national_ids", default: {}
    t.string "gateway"
    t.string "gateway_id", null: false
    t.jsonb "data", default: {}
    t.jsonb "minimum_requirements", default: {}
    t.jsonb "requirements", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.integer "token_expire_at"
    t.integer "login_count", default: 0, null: false
    t.integer "failed_login_count", default: 0, null: false
    t.datetime "last_login_at"
    t.string "last_login_ip"
    t.jsonb "devices", default: {}
    t.string "network_id"
    t.boolean "has_accepted_tdu", default: false
    t.index ["data"], name: "index_shippers_on_data", using: :gin
    t.index ["devices"], name: "index_shippers_on_devices", using: :gin
    t.index ["minimum_requirements"], name: "index_shippers_on_minimum_requirements", using: :gin
    t.index ["national_ids"], name: "index_shippers_on_national_ids", using: :gin
    t.index ["network_id"], name: "index_shippers_on_network_id"
    t.index ["requirements"], name: "index_shippers_on_requirements", using: :gin
  end

  create_table "trip_assignments", force: :cascade do |t|
    t.string "state"
    t.uuid "trip_id"
    t.uuid "shipper_id"
    t.datetime "created_at"
    t.jsonb "notification_payload", default: {}
    t.datetime "notified_at"
    t.datetime "closed_at"
    t.string "network_id"
    t.index ["closed_at"], name: "index_trip_assignments_on_closed_at", where: "(closed_at IS NULL)"
    t.index ["network_id"], name: "index_trip_assignments_on_network_id"
    t.index ["notification_payload"], name: "index_trip_assignments_on_notification_payload", using: :gin
    t.index ["shipper_id"], name: "index_trip_assignments_on_shipper_id"
    t.index ["state"], name: "index_trip_assignments_on_state"
    t.index ["trip_id", "shipper_id"], name: "index_trip_assignments_on_trip_id_and_shipper_id"
    t.index ["trip_id"], name: "index_trip_assignments_on_trip_id"
  end

  create_table "trips", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "shipper_id"
    t.string "status"
    t.string "comments"
    t.decimal "amount", precision: 12, scale: 4, default: "0.0"
    t.string "gateway"
    t.string "gateway_id"
    t.jsonb "gateway_data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "steps", default: [], null: false
    t.string "network_id"
    t.index ["gateway_data"], name: "index_trips_on_gateway_data", using: :gin
    t.index ["network_id"], name: "index_trips_on_network_id"
    t.index ["shipper_id"], name: "index_trips_on_shipper_id"
    t.index ["status"], name: "index_trips_on_status"
    t.index ["steps"], name: "index_trips_on_steps", using: :gin
  end

  create_table "untracked_activities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "institution_id"
    t.uuid "author_id"
    t.string "reason"
    t.string "activity"
    t.decimal "amount", precision: 12, scale: 4, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "network_id"
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
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "institution_id"
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["institution_id"], name: "index_users_on_institution_id"
    t.index ["roles_mask"], name: "index_users_on_roles_mask"
    t.index ["settings"], name: "index_users_on_settings", using: :gin
    t.index ["username"], name: "index_users_on_username"
  end

  create_table "vehicles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "shipper_id"
    t.string "model", null: false
    t.string "brand"
    t.integer "year"
    t.jsonb "extras", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "max_weight"
    t.string "network_id"
    t.index ["extras"], name: "index_vehicles_on_extras", using: :gin
    t.index ["network_id"], name: "index_vehicles_on_network_id"
    t.index ["shipper_id"], name: "index_vehicles_on_shipper_id"
  end

  create_table "verifications", force: :cascade do |t|
    t.string "verificable_type"
    t.uuid "verificable_id"
    t.jsonb "data", default: {}
    t.datetime "verified_at"
    t.uuid "verified_by"
    t.boolean "expire"
    t.datetime "expire_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "network_id"
    t.index ["data"], name: "index_verifications_on_data", using: :gin
    t.index ["network_id"], name: "index_verifications_on_network_id"
    t.index ["verificable_type", "verificable_id"], name: "index_verifications_on_verificable_type_and_verificable_id"
  end

  create_table "webhook_logs", force: :cascade do |t|
    t.string "service"
    t.string "path", limit: 1024
    t.jsonb "parsed_body", default: {}
    t.string "ip"
    t.string "user_agent"
    t.datetime "requested_at"
    t.index ["parsed_body"], name: "index_webhook_logs_on_parsed_body", using: :gin
  end

  add_foreign_key "addresses", "institutions"
  add_foreign_key "bank_accounts", "shippers"
  add_foreign_key "deliveries", "orders"
  add_foreign_key "deliveries", "trips"
  add_foreign_key "institutions", "districts"
  add_foreign_key "packages", "deliveries"
  add_foreign_key "trips", "shippers"
  add_foreign_key "vehicles", "shippers"
end
