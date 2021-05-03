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

ActiveRecord::Schema.define(version: 2021_05_02_075318) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "image_tags", force: :cascade do |t|
    t.integer "image_id", null: false
    t.string "tag_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["image_id", "tag_name"], name: "index_image_tags", unique: true
  end

  create_table "images", force: :cascade do |t|
    t.string "image_url", null: false
    t.string "name", null: false
    t.string "alt_text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["image_url"], name: "index_image_url", unique: true
  end

end
