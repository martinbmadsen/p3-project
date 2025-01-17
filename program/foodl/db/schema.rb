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

ActiveRecord::Schema.define(:version => 20121127130504) do

  create_table "food_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "alias_for"
  end

  add_index "food_types", ["name"], :name => "index_food_types_on_name", :unique => true

  create_table "ingredients", :force => true do |t|
    t.float    "quantity"
    t.string   "unit"
    t.integer  "food_type_id"
    t.integer  "recipe_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "name"
    t.float    "match"
    t.string   "original"
  end

  create_table "issue_categories", :force => true do |t|
    t.string   "name"
    t.boolean  "describable"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "issues", :force => true do |t|
    t.text     "description"
    t.integer  "issue_category_id"
    t.integer  "user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "list_items", :force => true do |t|
    t.float    "quantity"
    t.string   "name"
    t.string   "unit"
    t.integer  "user_id"
    t.integer  "food_type_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "recipes", :force => true do |t|
    t.string   "name"
    t.text     "url"
    t.binary   "picture"
    t.integer  "rating",     :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "prep_time"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
  end

  add_index "users", ["email"], :name => "email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "users_recipes", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "recipe_id"
  end

end
