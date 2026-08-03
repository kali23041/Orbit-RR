# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_03_075302) do
  create_table "availability_slots", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "ends_at", null: false
    t.integer "mentor_profile_id", null: false
    t.datetime "starts_at", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["mentor_profile_id", "starts_at"], name: "index_availability_slots_on_mentor_profile_id_and_starts_at"
    t.index ["mentor_profile_id"], name: "index_availability_slots_on_mentor_profile_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.integer "amount_cents", null: false
    t.integer "availability_slot_id", null: false
    t.datetime "created_at", null: false
    t.string "currency", default: "usd", null: false
    t.string "firebase_chat_path"
    t.integer "learner_id", null: false
    t.string "meet_url"
    t.integer "mentor_profile_id", null: false
    t.text "notes"
    t.integer "status", default: 0, null: false
    t.string "stripe_checkout_session_id"
    t.string "stripe_payment_intent_id"
    t.datetime "updated_at", null: false
    t.index ["availability_slot_id"], name: "index_bookings_on_availability_slot_id", unique: true
    t.index ["learner_id"], name: "index_bookings_on_learner_id"
    t.index ["mentor_profile_id"], name: "index_bookings_on_mentor_profile_id"
    t.index ["stripe_checkout_session_id"], name: "index_bookings_on_stripe_checkout_session_id", unique: true
  end

  create_table "mentor_profiles", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "currency", default: "usd", null: false
    t.string "headline", null: false
    t.integer "hourly_rate_cents", default: 5000, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "years_experience", default: 0
    t.index ["user_id"], name: "index_mentor_profiles_on_user_id", unique: true
  end

  create_table "mentor_skills", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "mentor_profile_id", null: false
    t.integer "skill_id", null: false
    t.datetime "updated_at", null: false
    t.index ["mentor_profile_id", "skill_id"], name: "index_mentor_skills_on_mentor_profile_id_and_skill_id", unique: true
    t.index ["mentor_profile_id"], name: "index_mentor_skills_on_mentor_profile_id"
    t.index ["skill_id"], name: "index_mentor_skills_on_skill_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "body"
    t.integer "booking_id", null: false
    t.datetime "created_at", null: false
    t.integer "rating", null: false
    t.integer "reviewer_id", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_reviews_on_booking_id", unique: true
    t.index ["reviewer_id"], name: "index_reviews_on_reviewer_id"
  end

  create_table "skills", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_skills_on_name", unique: true
    t.index ["slug"], name: "index_skills_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "firebase_uid", null: false
    t.string "name", null: false
    t.integer "role", default: 0, null: false
    t.string "timezone", default: "UTC"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["firebase_uid"], name: "index_users_on_firebase_uid", unique: true
  end

  add_foreign_key "availability_slots", "mentor_profiles"
  add_foreign_key "bookings", "availability_slots"
  add_foreign_key "bookings", "mentor_profiles"
  add_foreign_key "bookings", "users", column: "learner_id"
  add_foreign_key "mentor_profiles", "users"
  add_foreign_key "mentor_skills", "mentor_profiles"
  add_foreign_key "mentor_skills", "skills"
  add_foreign_key "reviews", "bookings"
  add_foreign_key "reviews", "users", column: "reviewer_id"
end
