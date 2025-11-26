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

ActiveRecord::Schema[8.0].define(version: 2025_11_26_031058) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.string "file"
    t.string "attachable_type"
    t.integer "attachable_id"
    t.integer "file_size"
    t.string "file_type"
    t.string "original_filename"
    t.string "file_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachable_type", "attachable_id"], name: "index_attachments_on_attachable_type_and_attachable_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "company_name", null: false
    t.string "tax_id"
    t.string "contact_name"
    t.string "contact_email"
    t.string "contact_phone"
    t.text "address"
    t.string "city"
    t.string "state"
    t.integer "client_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "materials", force: :cascade do |t|
    t.string "code", null: false
    t.string "title", null: false
    t.text "description"
    t.integer "unit", default: 0
    t.decimal "cost_price", precision: 10, scale: 2, default: "0.0"
    t.decimal "public_price", precision: 10, scale: 2, default: "0.0"
    t.integer "category", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "folio_number", null: false
    t.string "name", null: false
    t.text "description"
    t.bigint "client_id", null: false
    t.text "location"
    t.integer "project_type", default: 0
    t.integer "status", default: 0
    t.date "start_date"
    t.date "estimated_end_date"
    t.date "actual_end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "responsible_id"
    t.index ["client_id"], name: "index_projects_on_client_id"
  end

  create_table "quotation_items", force: :cascade do |t|
    t.bigint "quotation_id", null: false
    t.integer "type", default: 0
    t.text "description", null: false
    t.decimal "quantity", precision: 8, scale: 2, default: "0.0"
    t.integer "unit", default: 0
    t.decimal "unit_price", precision: 10, scale: 2, default: "0.0"
    t.decimal "amount", precision: 10, scale: 2, default: "0.0"
    t.integer "currency", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quotation_id"], name: "index_quotation_items_on_quotation_id"
  end

  create_table "quotations", force: :cascade do |t|
    t.string "quotation_number", null: false
    t.bigint "project_id", null: false
    t.bigint "client_id", null: false
    t.integer "project_type", default: 0
    t.date "publish_date"
    t.date "expiry_date"
    t.decimal "subtotal", precision: 10, scale: 2, default: "0.0"
    t.decimal "total", precision: 10, scale: 2, default: "0.0"
    t.integer "status", default: 0
    t.text "terms_conditions"
    t.text "notes"
    t.integer "revision_number", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "salesperson_id"
    t.index ["client_id"], name: "index_quotations_on_client_id"
    t.index ["project_id"], name: "index_quotations_on_project_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "code", null: false
    t.string "title", null: false
    t.text "description"
    t.integer "unit", default: 0
    t.decimal "suggested_price", precision: 10, scale: 2, default: "0.0"
    t.decimal "public_price", precision: 10, scale: 2, default: "0.0"
    t.integer "category", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "last_name"
    t.integer "role", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.integer "status", default: 1
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "whodunnit"
    t.datetime "created_at"
    t.bigint "item_id", null: false
    t.string "item_type", null: false
    t.string "event", null: false
    t.text "object"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "projects", "clients"
  add_foreign_key "quotation_items", "quotations"
  add_foreign_key "quotations", "clients"
  add_foreign_key "quotations", "projects"
end
