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

ActiveRecord::Schema[7.0].define(version: 2024_12_02_124358) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agreement_control_people", id: false, force: :cascade do |t|
    t.bigint "agreement_id", null: false
    t.bigint "control_person_id", null: false
    t.index ["agreement_id", "control_person_id"], name: "agreement_control_people_by_agreement"
    t.index ["control_person_id", "agreement_id"], name: "agreement_control_people_by_people"
  end

  create_table "agreement_processors", id: false, force: :cascade do |t|
    t.bigint "agreement_id", null: false
    t.bigint "processor_id", null: false
    t.index ["agreement_id", "processor_id"], name: "agreement_processors_by_agreement"
    t.index ["processor_id", "agreement_id"], name: "agreement_processors_by_processor"
  end

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

  create_table "data_tables", force: :cascade do |t|
    t.string "name"
    t.json "fields"
    t.string "record_id"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable"
  end

  create_table "power_agreements", id: false, force: :cascade do |t|
    t.bigint "power_id", null: false
    t.bigint "agreement_id", null: false
    t.index ["agreement_id", "power_id"], name: "index_power_agreements_on_agreement_id_and_power_id"
    t.index ["power_id", "agreement_id"], name: "index_power_agreements_on_power_id_and_agreement_id"
  end

  create_table "power_control_people", id: false, force: :cascade do |t|
    t.bigint "power_id", null: false
    t.bigint "control_person_id", null: false
    t.index ["control_person_id", "power_id"], name: "index_power_control_people_on_control_person_id_and_power_id"
    t.index ["power_id", "control_person_id"], name: "index_power_control_people_on_power_id_and_control_person_id"
  end

  create_table "update_logs", force: :cascade do |t|
    t.date "updated_on"
    t.string "comment"
    t.boolean "from_seeds", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
