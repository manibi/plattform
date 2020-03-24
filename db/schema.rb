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

ActiveRecord::Schema.define(version: 2020_03_24_114422) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "explanation"
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "category_id"
    t.boolean "draft", default: true
    t.datetime "published_at"
    t.index ["category_id"], name: "index_articles_on_category_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "topic_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["topic_id"], name: "index_categories_on_topic_id"
  end

  create_table "chapters", force: :cascade do |t|
    t.string "title"
    t.bigint "article_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id"], name: "index_chapters_on_article_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username"
    t.string "name"
    t.string "address"
    t.string "phone_number"
    t.string "contact_person_name"
    t.index ["email"], name: "index_companies_on_email"
    t.index ["reset_password_token"], name: "index_companies_on_reset_password_token", unique: true
    t.index ["username"], name: "index_companies_on_username", unique: true
  end

  create_table "company_credentials", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "password"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_company_credentials_on_user_id"
  end

  create_table "custom_exam_answers", force: :cascade do |t|
    t.boolean "answered", default: false
    t.boolean "correct", default: false
    t.bigint "custom_exam_id"
    t.bigint "flashcard_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "bookmarked", default: false
    t.boolean "answered_correct_in_exam", default: false
    t.text "user_answers"
    t.index ["custom_exam_id"], name: "index_custom_exam_answers_on_custom_exam_id"
    t.index ["flashcard_id"], name: "index_custom_exam_answers_on_flashcard_id"
  end

  create_table "custom_exams", force: :cascade do |t|
    t.text "questions"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "submitted", default: false
    t.index ["user_id"], name: "index_custom_exams_on_user_id"
  end

  create_table "flashcard_answers", force: :cascade do |t|
    t.bigint "flashcard_id", null: false
    t.bigint "answer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["answer_id"], name: "index_flashcard_answers_on_answer_id"
    t.index ["flashcard_id"], name: "index_flashcard_answers_on_flashcard_id"
  end

  create_table "flashcard_queues", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "article_id"
    t.text "flashcards_queue"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "tries", default: 0
    t.index ["article_id"], name: "index_flashcard_queues_on_article_id"
    t.index ["user_id"], name: "index_flashcard_queues_on_user_id"
  end

  create_table "flashcards", force: :cascade do |t|
    t.string "flashcard_type"
    t.text "correct_answers"
    t.bigint "article_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "draft", default: true
    t.datetime "published_at"
    t.index ["article_id"], name: "index_flashcards_on_article_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "professions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "temporary_user_credentials", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "first_name"
    t.string "last_name"
    t.string "company_name"
    t.string "school_name"
    t.string "email"
    t.date "birth_date"
    t.date "exam_date"
    t.integer "role"
    t.bigint "company_id"
    t.bigint "profession_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "sent_email", default: false
    t.text "feedback"
    t.index ["company_id"], name: "index_temporary_user_credentials_on_company_id"
    t.index ["profession_id"], name: "index_temporary_user_credentials_on_profession_id"
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
    t.boolean "author", default: false
    t.boolean "editor", default: false
    t.index ["article_id"], name: "index_user_articles_on_article_id"
    t.index ["user_id", "article_id"], name: "index_user_articles_on_user_id_and_article_id", unique: true
    t.index ["user_id"], name: "index_user_articles_on_user_id"
  end

  create_table "user_credentials", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.integer "role"
    t.bigint "user_id"
    t.bigint "company_id"
    t.bigint "profession_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_user_credentials_on_company_id"
    t.index ["profession_id"], name: "index_user_credentials_on_profession_id"
    t.index ["user_id"], name: "index_user_credentials_on_user_id"
  end

  create_table "user_flashcards", force: :cascade do |t|
    t.boolean "correct"
    t.bigint "flashcard_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "author", default: false
    t.boolean "editor", default: false
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
    t.integer "role"
    t.bigint "company_id"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email"
    t.index ["profession_id"], name: "index_users_on_profession_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "articles", "categories"
  add_foreign_key "categories", "topics"
  add_foreign_key "chapters", "articles"
  add_foreign_key "company_credentials", "users"
  add_foreign_key "custom_exam_answers", "custom_exams"
  add_foreign_key "custom_exam_answers", "flashcards"
  add_foreign_key "custom_exams", "users"
  add_foreign_key "flashcard_answers", "answers"
  add_foreign_key "flashcard_answers", "flashcards"
  add_foreign_key "flashcard_queues", "articles"
  add_foreign_key "flashcard_queues", "users"
  add_foreign_key "flashcards", "articles"
  add_foreign_key "temporary_user_credentials", "companies"
  add_foreign_key "temporary_user_credentials", "professions"
  add_foreign_key "topics", "professions"
  add_foreign_key "user_articles", "articles"
  add_foreign_key "user_articles", "users"
  add_foreign_key "user_credentials", "companies"
  add_foreign_key "user_credentials", "professions"
  add_foreign_key "user_credentials", "users"
  add_foreign_key "user_flashcards", "flashcards"
  add_foreign_key "user_flashcards", "users"
  add_foreign_key "users", "companies"
  add_foreign_key "users", "professions"
end
