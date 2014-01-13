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

ActiveRecord::Schema.define(version: 20140113024825) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "difficulties", force: true do |t|
    t.string   "difficulty"
    t.integer  "user_id"
    t.integer  "flash_card_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "difficulties", ["flash_card_id"], name: "index_difficulties_on_flash_card_id", using: :btree
  add_index "difficulties", ["user_id"], name: "index_difficulties_on_user_id", using: :btree

  create_table "drills", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "description"
    t.integer  "user_id"
  end

  create_table "examples", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "flash_card_id"
    t.string   "flash_card_type"
    t.text     "simplified"
    t.text     "traditional"
    t.text     "pinyin"
    t.text     "jyutping"
    t.text     "translation"
    t.text     "notes"
  end

  create_table "flash_cards", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "teachable_id"
    t.string   "teachable_type"
    t.string   "meaning"
    t.string   "part_of_speech"
    t.string   "simplified"
    t.string   "traditional"
    t.string   "pinyin"
    t.string   "jyutping"
  end

  create_table "lyrics", force: true do |t|
    t.text     "traditional"
    t.text     "simplified"
    t.text     "pronunciation"
    t.string   "dialect"
    t.text     "translation"
    t.text     "timing"
    t.integer  "song_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "passages", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.integer  "user_id"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "songs", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "artist"
    t.string   "url"
    t.integer  "user_id"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "username"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end
