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

ActiveRecord::Schema.define(:version => 20131125175808) do

  create_table "clubs", :force => true do |t|
    t.string   "name"
    t.string   "city"
    t.string   "street"
    t.integer  "zip"
    t.string   "country"
    t.float    "lat"
    t.float    "long"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "clubs", ["name"], :name => "index_clubs_on_name"
  add_index "clubs", ["zip"], :name => "index_clubs_on_zip"

  create_table "conversations", :force => true do |t|
    t.string   "subject",    :default => ""
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "friendships", :force => true do |t|
    t.integer  "friender_id"
    t.integer  "friended_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "confirmed",   :default => false
  end

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

  create_table "matches", :force => true do |t|
    t.integer  "player1_id"
    t.integer  "player2_id"
    t.integer  "winner_id"
    t.date     "play_date"
    t.text     "player1_score"
    t.text     "player2_score"
    t.boolean  "player1_confirm", :default => false
    t.boolean  "player2_confirm", :default => false
    t.boolean  "confirmed",       :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "club_id"
    t.integer  "rating"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "notifications", :force => true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              :default => ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                :default => false
    t.datetime "updated_at",                              :null => false
    t.datetime "created_at",                              :null => false
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "notification_code"
    t.string   "attachment"
    t.boolean  "global",               :default => false
    t.datetime "expires"
  end

  add_index "notifications", ["conversation_id"], :name => "index_notifications_on_conversation_id"

  create_table "receipts", :force => true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                                  :null => false
    t.boolean  "is_read",                       :default => false
    t.boolean  "trashed",                       :default => false
    t.boolean  "deleted",                       :default => false
    t.string   "mailbox_type",    :limit => 25
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  add_index "receipts", ["notification_id"], :name => "index_receipts_on_notification_id"

  create_table "users", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "password_digest"
    t.integer  "fb_id",                :limit => 8
    t.date     "birthdate"
    t.integer  "zip"
    t.float    "lat"
    t.float    "long"
    t.string   "fb_pic_small"
    t.string   "fb_pic_large"
    t.integer  "gender"
    t.integer  "first_rating"
    t.boolean  "has_played",                        :default => false
    t.text     "available_times"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "email"
    t.integer  "signup_method"
    t.string   "fb_pic_square"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "fullname"
    t.boolean  "friend_request_email",              :default => true
    t.boolean  "message_notify_email",              :default => true
    t.string   "country"
  end

  add_index "users", ["fb_id"], :name => "index_users_on_fb_id"

  add_foreign_key "notifications", "conversations", name: "notifications_on_conversation_id"

  add_foreign_key "receipts", "notifications", name: "receipts_on_notification_id"

end
