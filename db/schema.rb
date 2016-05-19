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

ActiveRecord::Schema.define(version: 20160427144201) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.integer  "business_id"
    t.string   "day"
    t.string   "street"
    t.string   "zipcode"
    t.string   "city"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "active",      default: true, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.datetime "start_time"
    t.datetime "end_time"
  end

  add_index "addresses", ["business_id"], name: "index_addresses_on_business_id", using: :btree

  create_table "business_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "color"
    t.string   "marker_symbol"
  end

  create_table "businesses", force: :cascade do |t|
    t.string   "name"
    t.string   "street"
    t.string   "zipcode"
    t.string   "city"
    t.string   "url"
    t.string   "telephone"
    t.string   "email"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.text     "description"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "business_category_id"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "instagram"
    t.string   "encrypted_password",          default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",               default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "leader_picture_file_name"
    t.string   "leader_picture_content_type"
    t.integer  "leader_picture_file_size"
    t.datetime "leader_picture_updated_at"
    t.string   "leader_first_name"
    t.string   "leader_last_name"
    t.text     "leader_description"
    t.boolean  "active",                      default: false, null: false
    t.boolean  "online",                      default: false, null: false
    t.string   "leader_phone"
    t.string   "leader_email"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.boolean  "shop",                        default: true,  null: false
    t.boolean  "itinerant",                   default: false, null: false
  end

  add_index "businesses", ["business_category_id"], name: "index_businesses_on_business_category_id", using: :btree
  add_index "businesses", ["email"], name: "index_businesses_on_email", unique: true, using: :btree
  add_index "businesses", ["reset_password_token"], name: "index_businesses_on_reset_password_token", unique: true, using: :btree

  create_table "cause_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "color"
  end

  create_table "causes", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "street"
    t.string   "zipcode"
    t.string   "city"
    t.string   "url"
    t.string   "email"
    t.string   "telephone"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "impact"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "cause_category_id"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "instagram"
    t.string   "description_impact"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "mangopay_id"
    t.string   "wallet_id"
    t.string   "representative_first_name"
    t.string   "representative_last_name"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "amount_impact"
    t.boolean  "active",                    default: false, null: false
  end

  add_index "causes", ["cause_category_id"], name: "index_causes_on_cause_category_id", using: :btree

  create_table "partners", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "code_partner"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "nb_month",     default: 1
  end

  create_table "periodicities", force: :cascade do |t|
    t.string   "period"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "perk_details", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "perks", force: :cascade do |t|
    t.string   "name"
    t.integer  "business_id"
    t.text     "description"
    t.integer  "times",                default: 0
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "active",               default: true,  null: false
    t.string   "perk_code"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "nb_views",             default: 0
    t.boolean  "appel",                default: false, null: false
    t.boolean  "durable",              default: false, null: false
    t.boolean  "flash",                default: false, null: false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "perk_detail_id"
    t.boolean  "deleted",              default: false, null: false
    t.boolean  "all_day",              default: false, null: false
  end

  add_index "perks", ["business_id"], name: "index_perks_on_business_id", using: :btree
  add_index "perks", ["perk_detail_id"], name: "index_perks_on_perk_detail_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "token"
    t.datetime "token_expiry"
    t.boolean  "admin",                  default: false, null: false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "birthday"
    t.string   "nationality"
    t.string   "country_of_residence"
    t.string   "mangopay_id"
    t.string   "card_id"
    t.integer  "cause_id"
    t.boolean  "member",                 default: false, null: false
    t.string   "subscription"
    t.boolean  "trial_done",             default: false, null: false
    t.datetime "date_subscription"
    t.datetime "date_last_payment"
    t.boolean  "active",                 default: false, null: false
    t.string   "street"
    t.string   "zipcode"
    t.string   "city"
    t.float    "latitude"
    t.float    "longitude"
    t.date     "date_partner"
    t.string   "code_partner"
    t.date     "date_support"
  end

  add_index "users", ["cause_id"], name: "index_users_on_cause_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "uses", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "perk_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "uses", ["perk_id"], name: "index_uses_on_perk_id", using: :btree
  add_index "uses", ["user_id"], name: "index_uses_on_user_id", using: :btree

  add_foreign_key "addresses", "businesses"
  add_foreign_key "perks", "businesses"
  add_foreign_key "users", "causes"
  add_foreign_key "uses", "perks"
  add_foreign_key "uses", "users"
end
