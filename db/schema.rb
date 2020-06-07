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

ActiveRecord::Schema.define(version: 2020_06_06_102108) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_levels", force: :cascade do |t|
    t.string "object_type", null: false
    t.bigint "object_id", null: false
    t.bigint "user_id", null: false
    t.boolean "write", default: false, null: false
    t.boolean "read", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["object_type", "object_id"], name: "index_access_levels_on_object_type_and_object_id"
    t.index ["user_id"], name: "index_access_levels_on_user_id"
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

  create_table "folder_files", force: :cascade do |t|
    t.bigint "folder_id", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["folder_id"], name: "index_folder_files_on_folder_id"
  end

  create_table "folders", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.integer "parent_id"
    t.integer "lft", null: false
    t.integer "rgt", null: false
    t.integer "depth", default: 0, null: false
    t.integer "children_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lft"], name: "index_folders_on_lft"
    t.index ["parent_id"], name: "index_folders_on_parent_id"
    t.index ["rgt"], name: "index_folders_on_rgt"
    t.index ["user_id"], name: "index_folders_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "system_id", null: false
    t.bigint "master_id", null: false
    t.string "name", null: false
    t.boolean "open", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["master_id"], name: "index_games_on_master_id"
    t.index ["system_id"], name: "index_games_on_system_id"
  end

  create_table "graphics", force: :cascade do |t|
    t.bigint "page_id", null: false
    t.string "layer"
    t.jsonb "params"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["layer"], name: "index_graphics_on_layer"
    t.index ["page_id"], name: "index_graphics_on_page_id"
  end

  create_table "menus", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.jsonb "params", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "identifier", null: false
    t.index ["game_id"], name: "index_menus_on_game_id"
  end

  create_table "menus_items", force: :cascade do |t|
    t.bigint "menu_id", null: false
    t.jsonb "params", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["menu_id"], name: "index_menus_items_on_menu_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "user_id", null: false
    t.bigint "whisper_to_id"
    t.jsonb "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_messages_on_game_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
    t.index ["whisper_to_id"], name: "index_messages_on_whisper_to_id"
  end

  create_table "pages", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.string "name", null: false
    t.jsonb "params", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_pages_on_game_id"
  end

  create_table "sheets", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "owner_id", null: false
    t.boolean "read_all", default: false, null: false
    t.boolean "write_all", default: false, null: false
    t.string "name", null: false
    t.jsonb "params", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "sheet_type", null: false
    t.index ["game_id", "owner_id"], name: "index_sheets_on_game_id_and_owner_id"
    t.index ["game_id"], name: "index_sheets_on_game_id"
    t.index ["owner_id"], name: "index_sheets_on_owner_id"
  end

  create_table "systems", force: :cascade do |t|
    t.string "name", null: false
    t.string "key", null: false
    t.string "version", null: false
    t.jsonb "template", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tokens", force: :cascade do |t|
    t.bigint "page_id", null: false
    t.bigint "sheet_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "params", default: {}, null: false
    t.boolean "read_all", default: false, null: false
    t.boolean "write_all", default: false, null: false
    t.index ["page_id"], name: "index_tokens_on_page_id"
    t.index ["sheet_id"], name: "index_tokens_on_sheet_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "nickname", null: false
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "jti", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_in_games", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id", "user_id"], name: "index_users_in_games_on_game_id_and_user_id"
    t.index ["game_id"], name: "index_users_in_games_on_game_id"
    t.index ["user_id"], name: "index_users_in_games_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
