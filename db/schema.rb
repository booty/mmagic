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

ActiveRecord::Schema[7.0].define(version: 2022_05_08_063931) do
  create_table "checklist_items", force: :cascade do |t|
    t.integer "place_id", null: false
    t.json "contents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_checklist_items_on_place_id"
  end

  create_table "checklists", force: :cascade do |t|
    t.integer "parent_id"
    t.integer "place_id", null: false
    t.string "name", null: false
    t.json "contents"
    t.datetime "published_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "place_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "place_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "place_desc_idx"
  end

  create_table "places", force: :cascade do |t|
    t.integer "parent_id"
    t.integer "place_type", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sensor_readings", force: :cascade do |t|
    t.integer "sensor_id", null: false
    t.decimal "value", precision: 16, scale: 4, null: false
    t.datetime "created_at", precision: nil
    t.index ["sensor_id"], name: "index_sensor_readings_on_sensor_id"
  end

  create_table "sensor_types", force: :cascade do |t|
    t.string "name", null: false
    t.string "units_numerator", null: false
    t.string "units_denominator"
    t.string "units_numerator_abbreviation", null: false
    t.string "units_denominator_abbreviation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sensors", force: :cascade do |t|
    t.string "name"
    t.integer "sensor_type_id", null: false
    t.integer "place_id", null: false
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_sensors_on_place_id"
    t.index ["sensor_type_id"], name: "index_sensors_on_sensor_type_id"
  end

  add_foreign_key "sensor_readings", "sensors"
  add_foreign_key "sensors", "places"
  add_foreign_key "sensors", "sensor_types"
end
