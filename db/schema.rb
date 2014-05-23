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

ActiveRecord::Schema.define(version: 20140519203737) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true

  create_table "customer_items", force: true do |t|
    t.integer  "customer_id"
    t.integer  "product_id"
    t.datetime "latest_reference_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_shopping_list_items", force: true do |t|
    t.integer  "customer_shopping_list_id"
    t.integer  "product_id"
    t.decimal  "quantity"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_shopping_lists", force: true do |t|
    t.integer  "customer_id"
    t.string   "shopping_list_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "account_no"
    t.integer  "preferred_store_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "nick_name"
    t.string   "home_phone"
    t.string   "cell_phone"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.integer  "state_id"
    t.string   "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "food_features", force: true do |t|
    t.string   "name"
    t.string   "descr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.string   "sku"
    t.string   "upc"
    t.string   "brand"
    t.string   "descr"
    t.string   "qty_desc"
    t.decimal  "min_qty_weight"
    t.string   "image"
    t.string   "category"
    t.string   "sub_category"
    t.string   "sub_category_group"
    t.string   "uofm"
    t.decimal  "price"
    t.decimal  "sale_price"
    t.boolean  "on_sale"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "featured_item"
    t.string   "food_feature"
  end

  create_table "states", force: true do |t|
    t.string   "state"
    t.string   "state2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stores", force: true do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.integer  "state_id"
    t.string   "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
