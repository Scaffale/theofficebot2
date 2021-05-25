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

ActiveRecord::Schema.define(version: 20_210_524_151_616) do
  create_table 'choosen_results', charset: 'utf8', force: :cascade do |t|
    t.string 'uniq_id'
    t.bigint 'query_history_id'
    t.integer 'hits'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'query_histories', charset: 'utf8', force: :cascade do |t|
    t.string 'text'
    t.integer 'hits'
    t.float 'time_after'
    t.float 'time_before'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'sentences', charset: 'utf8', force: :cascade do |t|
    t.string 'file_name'
    t.string 'end_time'
    t.string 'start_time'
    t.string 'text'
  end
end
