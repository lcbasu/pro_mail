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

ActiveRecord::Schema.define(version: 20180422122502) do

  create_table "emails", force: :cascade do |t|
    t.text "body"
    t.string "subject"
    t.boolean "is_draft"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "index_emails_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_emails_on_user_id"
  end

  create_table "sender_receivers", force: :cascade do |t|
    t.integer "sender_user_id"
    t.integer "receiver_user_id"
    t.boolean "is_opened"
    t.boolean "is_deleted_by_sender"
    t.boolean "is_deleted_by_receiver"
    t.integer "email_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_id"], name: "index_sender_receivers_on_email_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

end
