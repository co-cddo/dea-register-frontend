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

ActiveRecord::Schema[7.0].define(version: 2023_06_15_145223) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "air_table_bases", force: :cascade do |t|
    t.string "name"
    t.string "permission_level"
    t.string "base_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "air_table_tables", force: :cascade do |t|
    t.string "name"
    t.string "record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "air_tables", force: :cascade do |t|
    t.string "name"
    t.json "fields"
    t.string "record_id"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "power_agreements", id: false, force: :cascade do |t|
    t.bigint "power_id", null: false
    t.bigint "agreement_id", null: false
    t.index ["agreement_id", "power_id"], name: "index_power_agreements_on_agreement_id_and_power_id"
    t.index ["power_id", "agreement_id"], name: "index_power_agreements_on_power_id_and_agreement_id"
  end

end
