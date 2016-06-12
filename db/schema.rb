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

ActiveRecord::Schema.define(version: 20160612210828) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cart_roles", force: :cascade do |t|
    t.integer "user_id"
    t.integer "cart_id"
    t.integer "role_id"
  end

  create_table "carts", force: :cascade do |t|
    t.integer  "status_id"
    t.datetime "expiry"
    t.integer  "minimum_payment"
    t.string   "name"
    t.integer  "total_paid"
    t.integer  "target_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key"
  end

  create_table "notification_templates", force: :cascade do |t|
    t.integer "role_id"
    t.text    "email_text"
    t.text    "ui_text"
    t.string  "description"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "cart_id"
    t.integer  "notification_template_id"
    t.datetime "created_at"
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "cart_id"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_customer_id"
    t.string   "stripe_charge_id"
    t.string   "status",             default: "paid"
  end

  create_table "products", force: :cascade do |t|
    t.integer  "cart_id"
    t.string   "url"
    t.string   "display_name"
    t.string   "external_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: :cascade do |t|
    t.string "role_text"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "text"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "final_boss",       default: false
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
  end

end
