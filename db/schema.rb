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

ActiveRecord::Schema.define(:version => 20131109073336) do

  create_table "invitations", :force => true do |t|
    t.integer  "inviter_id"
    t.integer  "invitee_id"
    t.boolean  "accepted"
    t.text     "message"
    t.string   "email"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "invite_method"
    t.integer  "fb_id",         :limit => 8
    t.boolean  "clicked"
  end

  add_index "invitations", ["email"], :name => "index_invitations_on_email"
  add_index "invitations", ["fb_id"], :name => "index_invitations_on_fb_id"
  add_index "invitations", ["invitee_id"], :name => "index_invitations_on_invitee_id"

  create_table "users", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "password_digest"
    t.integer  "fb_id",              :limit => 8
    t.date     "birthdate"
    t.integer  "zip"
    t.float    "lat"
    t.float    "long"
    t.string   "fb_pic_small"
    t.string   "fb_pic_large"
    t.integer  "gender"
    t.integer  "first_rating"
    t.boolean  "has_played",                      :default => false
    t.text     "available_times"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "email"
    t.integer  "signup_method"
    t.string   "fb_pic_square"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "users", ["fb_id"], :name => "index_users_on_fb_id"

end
