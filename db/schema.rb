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

ActiveRecord::Schema.define(version: 20150620002758) do

  create_table "addresses", force: :cascade do |t|
    t.integer "unit_number"
    t.integer "street_number"
    t.string  "street_name"
    t.string  "city"
  end

  create_table "landlords", force: :cascade do |t|
    t.integer "user_id"
    t.string  "full_name"
    t.float   "average_rating"
    t.boolean "friendly",              default: false
    t.float   "average_communication"
    t.float   "average_reliability"
    t.float   "average_helpfulness"
  end

  add_index "landlords", ["user_id"], name: "index_landlords_on_user_id"

  create_table "ratings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "landlord_id"
    t.integer  "communication"
    t.integer  "helpfulness"
    t.integer  "reliability"
    t.boolean  "friendly"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["landlord_id"], name: "index_ratings_on_landlord_id"
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id"

  create_table "rentals", force: :cascade do |t|
    t.integer "landlord_id"
    t.integer "address_id"
  end

  add_index "rentals", ["address_id"], name: "index_rentals_on_address_id"
  add_index "rentals", ["landlord_id"], name: "index_rentals_on_landlord_id"

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_hash"
    t.string   "password_salt"
  end

end
