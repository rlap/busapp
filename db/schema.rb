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

ActiveRecord::Schema.define(version: 20140708102551) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audio_clips", force: true do |t|
    t.string   "name"
    t.text     "audio_file"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "route_id"
    t.float    "longitude"
    t.float    "latitude"
    t.string   "address"
    t.boolean  "main_attraction", default: false
    t.string   "image_file"
    t.float    "east_sequence"
    t.float    "west_sequence"
  end

  add_index "audio_clips", ["route_id"], name: "index_audio_clips_on_route_id", using: :btree

  create_table "route_sequences", force: true do |t|
    t.integer  "stop_id"
    t.integer  "route_id"
    t.string   "route_name"
    t.integer  "direction"
    t.integer  "sequence"
    t.float    "east_sequence"
    t.float    "west_sequence"
    t.integer  "stop_code"
    t.string   "stop_name"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "northing"
    t.integer  "easting"
  end

  add_index "route_sequences", ["route_id"], name: "index_route_sequences_on_route_id", using: :btree
  add_index "route_sequences", ["stop_id"], name: "index_route_sequences_on_stop_id", using: :btree

  create_table "routes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "number"
    t.string   "description"
    t.string   "start_stop"
    t.string   "end_stop"
  end

  create_table "stops", force: true do |t|
    t.string   "stop_code"
    t.string   "stop_name"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "easting"
    t.integer  "northing"
  end

  create_table "user_routes", force: true do |t|
    t.integer  "user_id"
    t.integer  "route_id"
    t.integer  "direction"
    t.integer  "start_stop_id"
    t.boolean  "current"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_clip_id"
  end

  add_index "user_routes", ["route_id"], name: "index_user_routes_on_route_id", using: :btree
  add_index "user_routes", ["user_id"], name: "index_user_routes_on_user_id", using: :btree

  create_table "users", force: true do |t|
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
    t.string   "user_name"
    t.float    "longitude"
    t.float    "latitude"
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
