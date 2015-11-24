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

ActiveRecord::Schema.define(version: 20151124132853) do

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

  create_table "business_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "businesses", force: :cascade do |t|
    t.string   "name"
    t.string   "street"
    t.string   "zipcode"
    t.string   "city"
    t.string   "url"
    t.string   "telephone"
    t.string   "email"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "description"
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
    t.string   "user_picture_file_name"
    t.string   "user_picture_content_type"
    t.string   "user_picture_file_size"
    t.datetime "user_picture_updated_at"
  end

  add_index "businesses", ["business_category_id"], name: "index_businesses_on_business_category_id", using: :btree

  create_table "cause_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
  end

  create_table "causes", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "street"
    t.string   "zipcode"
    t.string   "city"
    t.string   "url"
    t.string   "email"
    t.string   "telephone"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
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
  end

  add_index "causes", ["cause_category_id"], name: "index_causes_on_cause_category_id", using: :btree

  create_table "periodicities", force: :cascade do |t|
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "perks", force: :cascade do |t|
    t.string   "perk"
    t.integer  "business_id"
    t.text     "description"
    t.string   "detail"
    t.integer  "periodicity_id"
    t.integer  "times"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "permanent"
    t.boolean  "flash"
    t.boolean  "active"
    t.string   "perk_code"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "perks", ["business_id"], name: "index_perks_on_business_id", using: :btree
  add_index "perks", ["periodicity_id"], name: "index_perks_on_periodicity_id", using: :btree

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
    t.string   "picture"
    t.string   "name"
    t.string   "token"
    t.datetime "token_expiry"
    t.boolean  "admin",                  default: false, null: false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "perks", "businesses"
  add_foreign_key "perks", "periodicities"
end
