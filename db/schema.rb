# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_11_120931) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "topic_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["topic_id"], name: "index_articles_on_topic_id"
  end

  create_table "chapters", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.bigint "article_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id"], name: "index_chapters_on_article_id"
  end

  create_table "flashcard_answers", force: :cascade do |t|
    t.bigint "flashcard_id", null: false
    t.bigint "answer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["answer_id"], name: "index_flashcard_answers_on_answer_id"
    t.index ["flashcard_id"], name: "index_flashcard_answers_on_flashcard_id"
  end

  create_table "flashcards", force: :cascade do |t|
    t.text "content"
    t.string "flashcard_type"
    t.text "correct_answers"
    t.bigint "article_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id"], name: "index_flashcards_on_article_id"
  end

  create_table "professions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
    t.bigint "profession_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["profession_id"], name: "index_topics_on_profession_id"
  end

  create_table "user_articles", force: :cascade do |t|
    t.boolean "read", default: false
    t.boolean "bookmarked", default: false
    t.bigint "user_id", null: false
    t.bigint "article_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id"], name: "index_user_articles_on_article_id"
    t.index ["user_id", "article_id"], name: "index_user_articles_on_user_id_and_article_id", unique: true
    t.index ["user_id"], name: "index_user_articles_on_user_id"
  end

  create_table "user_flashcards", force: :cascade do |t|
    t.boolean "correct"
    t.bigint "flashcard_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["flashcard_id"], name: "index_user_flashcards_on_flashcard_id"
    t.index ["user_id"], name: "index_user_flashcards_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username"
    t.string "first_name"
    t.date "birth_date"
    t.date "exam_date"
    t.string "last_name"
    t.bigint "profession_id"
    t.index ["email"], name: "index_users_on_email"
    t.index ["profession_id"], name: "index_users_on_profession_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "articles", "topics"
  add_foreign_key "chapters", "articles"
  add_foreign_key "flashcard_answers", "answers"
  add_foreign_key "flashcard_answers", "flashcards"
  add_foreign_key "flashcards", "articles"
  add_foreign_key "topics", "professions"
  add_foreign_key "user_articles", "articles"
  add_foreign_key "user_articles", "users"
  add_foreign_key "user_flashcards", "flashcards"
  add_foreign_key "user_flashcards", "users"
  add_foreign_key "users", "professions"
end
