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

ActiveRecord::Schema.define(version: 2021_05_29_093519) do

  create_table "choosen_results", charset: "utf8", force: :cascade do |t|
    t.string "uniq_id"
    t.bigint "query_history_id"
    t.integer "hits"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "query_histories", charset: "utf8", force: :cascade do |t|
    t.string "text"
    t.integer "hits"
    t.float "time_after"
    t.float "time_before"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "query_histories_words", id: false, charset: "utf8", force: :cascade do |t|
    t.bigint "query_history_id", null: false
    t.bigint "word_id", null: false
    t.index ["query_history_id", "word_id"], name: "index_query_histories_words_on_query_history_id_and_word_id"
  end

  create_table "sentences", charset: "utf8", force: :cascade do |t|
    t.string "file_name"
    t.string "end_time"
    t.string "start_time"
    t.string "text"
    t.string "file_filter"
  end

  create_table "sentences_words", id: false, charset: "utf8", force: :cascade do |t|
    t.bigint "sentence_id", null: false
    t.bigint "word_id", null: false
    t.index ["sentence_id", "word_id"], name: "index_sentences_words_on_sentence_id_and_word_id"
  end

  create_table "words", charset: "utf8", force: :cascade do |t|
    t.string "text"
  end

end
