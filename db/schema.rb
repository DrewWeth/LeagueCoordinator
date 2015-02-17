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

ActiveRecord::Schema.define(version: 20150217024524) do

  create_table "competitions", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "at"
    t.boolean  "active",      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "image"
  end

  add_index "competitions", ["user_id"], name: "index_competitions_on_user_id"

  create_table "players_in_competitions", force: true do |t|
    t.integer  "competition_id"
    t.integer  "user_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players_in_competitions", ["competition_id"], name: "index_players_in_competitions_on_competition_id"
  add_index "players_in_competitions", ["team_id"], name: "index_players_in_competitions_on_team_id"
  add_index "players_in_competitions", ["user_id"], name: "index_players_in_competitions_on_user_id"

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "teams", force: true do |t|
    t.string   "name"
    t.boolean  "active",         default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "competition_id"
    t.integer  "count",          default: 0
    t.integer  "user_id"
  end

  add_index "teams", ["competition_id"], name: "index_teams_on_competition_id"
  add_index "teams", ["user_id"], name: "index_teams_on_user_id"

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
    t.string   "summoner_name"
    t.string   "phone"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

end
