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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130809084743) do

  create_table "drills", :force => true do |t|
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "title",       :null => false
    t.string   "description", :null => false
  end

  create_table "examples", :force => true do |t|
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "flash_card_id"
    t.string   "flash_card_type"
    t.text     "simplified",      :null => false
    t.text     "traditional",     :null => false
    t.text     "pinyin",          :null => false
    t.text     "zhuyin",          :null => false
    t.text     "jyutping",        :null => false
    t.text     "translation",     :null => false
    t.text     "notes"
  end

  create_table "flash_cards", :force => true do |t|
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "teachable_id",   :null => false
    t.string   "teachable_type", :null => false
    t.string   "meaning",        :null => false
    t.string   "part_of_speech", :null => false
    t.string   "simplified",     :null => false
    t.string   "traditional",    :null => false
    t.string   "pinyin",         :null => false
    t.string   "zhuyin",         :null => false
    t.string   "jyutping",       :null => false
  end

  create_table "passages", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "title"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "songs", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "title"
    t.string   "artist"
    t.string   "url"
  end

end
