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

ActiveRecord::Schema.define(version: 20130803185251) do

  create_table "entities", force: true do |t|
    t.string   "name",                                      null: false
    t.string   "description",    limit: 90
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "priority",                                  null: false
    t.string   "short_name"
    t.string   "twitter_handle"
    t.string   "wikipedia_page"
    t.string   "facebook_page"
    t.string   "flickr_page"
    t.string   "linkedin_page"
    t.text     "notes"
    t.string   "slug"
    t.boolean  "person",                    default: true,  null: false
    t.boolean  "published",                 default: false, null: false
  end

  add_index "entities", ["person"], name: "index_entities_on_person", using: :btree
  add_index "entities", ["published"], name: "index_entities_on_published", using: :btree
  add_index "entities", ["slug"], name: "index_entities_on_slug", using: :btree

  create_table "photos", force: true do |t|
    t.string   "file"
    t.string   "title",                      null: false
    t.string   "copyright"
    t.boolean  "published",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "photos", ["published"], name: "index_photos_on_published", using: :btree
  add_index "photos", ["slug"], name: "index_photos_on_slug", using: :btree

  create_table "posts", force: true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id"
    t.string   "title",                      null: false
    t.boolean  "published",  default: false, null: false
    t.text     "notes"
    t.string   "slug"
  end

  add_index "posts", ["author_id"], name: "index_posts_on_author_id", using: :btree
  add_index "posts", ["slug"], name: "index_posts_on_slug", using: :btree

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   default: "",    null: false
    t.boolean  "admin",                  default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
