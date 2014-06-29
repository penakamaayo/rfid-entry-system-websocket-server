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

ActiveRecord::Schema.define(version: 20140225105234) do

  create_table "rfid_logs", force: true do |t|
    t.string   "card_rfid"
    t.datetime "time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "in_out"
    t.string   "full_name"
    t.string   "id_number"
    t.string   "classification"
    t.string   "plate_number"
    t.string   "vehicle_color"
    t.string   "vehicle_model"
  end

  create_table "students", force: true do |t|
    t.string   "card_rfid"
    t.string   "id_number"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "course"
    t.integer  "year_level"
    t.string   "contact_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stype"
    t.boolean  "entered"
    t.string   "vehicle_model"
    t.string   "vehicle_color"
    t.string   "plate_number"
  end

end
