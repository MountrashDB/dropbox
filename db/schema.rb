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

ActiveRecord::Schema[7.0].define(version: 2023_12_20_025929) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "authentication_token"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "alamat_jemputs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "latitude"
    t.string "longitude"
    t.string "kodepos"
    t.string "catatan"
    t.string "alamat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.index ["user_id"], name: "index_alamat_jemputs_on_user_id"
  end

  create_table "banks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "kode_bank"
    t.string "name"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url_image"
  end

  create_table "banksampahs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid"
    t.string "name"
    t.string "code"
    t.string "activation_code"
    t.string "phone"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "active"
    t.string "address"
    t.bigint "province_id"
    t.bigint "city_id"
    t.bigint "district_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "latitude"
    t.string "longitude"
    t.index ["city_id"], name: "index_banksampahs_on_city_id"
    t.index ["district_id"], name: "index_banksampahs_on_district_id"
    t.index ["email"], name: "index_banksampahs_on_email", unique: true
    t.index ["province_id"], name: "index_banksampahs_on_province_id"
    t.index ["reset_password_token"], name: "index_banksampahs_on_reset_password_token", unique: true
  end

  create_table "botol_hargas", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "botol_id", null: false
    t.float "harga"
    t.bigint "box_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.index ["botol_id"], name: "index_botol_hargas_on_botol_id"
    t.index ["box_id"], name: "index_botol_hargas_on_box_id"
  end

  create_table "botols", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "uuid"
    t.string "ukuran"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "barcode"
    t.string "jenis"
    t.string "product"
  end

  create_table "boxes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid"
    t.string "qr_code"
    t.string "latitude"
    t.string "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "max"
    t.string "nama"
    t.string "jenis"
    t.float "qty"
    t.float "revenue"
    t.string "cycles"
    t.datetime "dates"
    t.integer "mitra_id"
    t.string "mitra_info"
    t.integer "admin_id"
    t.float "mitra_share"
    t.float "user_share"
    t.string "type_progress"
    t.integer "user_id"
    t.integer "botol_total"
    t.float "price_pcs"
    t.float "price_kg"
    t.integer "failed", default: 0
    t.boolean "online"
    t.datetime "last_online"
  end

  create_table "bsi_transactions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "banksampah_id", null: false
    t.float "balance"
    t.float "credit"
    t.float "debit"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["banksampah_id"], name: "index_bsi_transactions_on_banksampah_id"
  end

  create_table "bsi_vas", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "banksampah_id", null: false
    t.boolean "active"
    t.string "bank_name"
    t.datetime "expired"
    t.float "fee"
    t.string "kodeBank"
    t.string "name"
    t.string "rekening"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["banksampah_id"], name: "index_bsi_vas_on_banksampah_id"
  end

  create_table "bukti_pembayarans", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "mitra_id", null: false
    t.float "nominal"
    t.string "status"
    t.bigint "admin_id"
    t.string "keterangan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_bukti_pembayarans_on_admin_id"
    t.index ["mitra_id"], name: "index_bukti_pembayarans_on_mitra_id"
  end

  create_table "callbacks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "body"
    t.text "headers"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "province_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["province_id"], name: "index_cities_on_province_id"
  end

  create_table "districts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "province_id", null: false
    t.bigint "city_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_districts_on_city_id"
    t.index ["province_id"], name: "index_districts_on_province_id"
  end

  create_table "harga_sampahs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "banksampah_id", null: false
    t.bigint "tipe_sampah_id", null: false
    t.float "harga_kg"
    t.float "harga_satuan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["banksampah_id"], name: "index_harga_sampahs_on_banksampah_id"
    t.index ["tipe_sampah_id"], name: "index_harga_sampahs_on_tipe_sampah_id"
  end

  create_table "histories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.float "amount"
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_histories_on_user_id"
  end

  create_table "investors", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "status"
    t.float "credit"
    t.float "debit"
    t.float "balance"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jam_jemputs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "label"
    t.integer "urut"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jemputan_details", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "jemputan_id", null: false
    t.bigint "tipe_sampah_id", null: false
    t.integer "qty"
    t.float "harga"
    t.float "sub_total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jemputan_id"], name: "index_jemputan_details_on_jemputan_id"
    t.index ["tipe_sampah_id"], name: "index_jemputan_details_on_tipe_sampah_id"
  end

  create_table "jemputans", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "status"
    t.string "catatan"
    t.bigint "alamat_jemput_id", null: false
    t.bigint "jam_jemput_id", null: false
    t.string "uuid"
    t.string "phone"
    t.float "sub_total"
    t.float "fee"
    t.float "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "tanggal"
    t.string "gambar"
    t.float "berat"
    t.index ["alamat_jemput_id"], name: "index_jemputans_on_alamat_jemput_id"
    t.index ["jam_jemput_id"], name: "index_jemputans_on_jam_jemput_id"
    t.index ["user_id"], name: "index_jemputans_on_user_id"
  end

  create_table "kycs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "no_ktp"
    t.string "nama"
    t.string "tempat_tinggal"
    t.date "tgl_lahir"
    t.string "rt"
    t.string "rw"
    t.string "desa"
    t.bigint "province_id", null: false
    t.bigint "city_id", null: false
    t.bigint "district_id", null: false
    t.bigint "mitra_id", null: false
    t.integer "status"
    t.string "agama"
    t.string "pekerjaan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.index ["city_id"], name: "index_kycs_on_city_id"
    t.index ["district_id"], name: "index_kycs_on_district_id"
    t.index ["mitra_id"], name: "index_kycs_on_mitra_id"
    t.index ["province_id"], name: "index_kycs_on_province_id"
  end

  create_table "merks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mitra_banks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.boolean "is_valid"
    t.string "kodeBank"
    t.string "nama"
    t.string "nama_bank"
    t.string "rekening"
    t.bigint "mitra_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mitra_id"], name: "index_mitra_banks_on_mitra_id"
  end

  create_table "mitra_vas", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "mitra_id", null: false
    t.string "kodeBank"
    t.boolean "active"
    t.float "fee"
    t.string "rekening"
    t.string "bank_name"
    t.string "name"
    t.datetime "expired"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mitra_id"], name: "index_mitra_vas_on_mitra_id"
  end

  create_table "mitras", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid"
    t.string "phone"
    t.string "name"
    t.string "contact"
    t.string "address"
    t.string "email"
    t.string "avatar"
    t.string "encrypted_password"
    t.integer "terms"
    t.integer "status"
    t.datetime "dates"
    t.string "activation_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "partner_id"
  end

  create_table "mitratransactions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "mitra_id", null: false
    t.float "credit", default: 0.0
    t.float "debit", default: 0.0
    t.float "balance", default: 0.0
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mitra_id"], name: "index_mitratransactions_on_mitra_id"
  end

  create_table "mountpays", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "mitra_id"
    t.float "credit"
    t.float "debit"
    t.float "balance"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "banksampah_id"
    t.index ["mitra_id"], name: "index_mountpays_on_mitra_id"
    t.index ["user_id"], name: "index_mountpays_on_user_id"
  end

  create_table "order_details", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "order_sampah_id", null: false
    t.bigint "sampah_id", null: false
    t.string "satuan"
    t.float "harga"
    t.float "qty"
    t.float "sub_total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_sampah_id"], name: "index_order_details_on_order_sampah_id"
    t.index ["sampah_id"], name: "index_order_details_on_sampah_id"
  end

  create_table "order_sampahs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "banksampah_id", null: false
    t.float "sub_total"
    t.float "total"
    t.string "status"
    t.string "uuid"
    t.float "fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["banksampah_id"], name: "index_order_sampahs_on_banksampah_id"
    t.index ["user_id"], name: "index_order_sampahs_on_user_id"
  end

  create_table "orders", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid"
    t.bigint "user_id", null: false
    t.bigint "box_id", null: false
    t.string "status"
    t.float "fee"
    t.float "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["box_id"], name: "index_orders_on_box_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "outlets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.boolean "active"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_outlets_on_email", unique: true
    t.index ["reset_password_token"], name: "index_outlets_on_reset_password_token", unique: true
  end

  create_table "partners", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid"
    t.string "nama"
    t.string "nama_usaha"
    t.string "handphone"
    t.text "alamat_kantor"
    t.string "email"
    t.string "password_digest"
    t.boolean "verified"
    t.boolean "approved"
    t.string "api_key"
    t.string "api_secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ppobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "body"
    t.string "status"
    t.float "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ref_id"
    t.integer "tr_id"
    t.string "ppob_type"
    t.float "profit"
    t.float "vendor_price"
    t.string "desc"
    t.json "body_params"
    t.index ["user_id"], name: "index_ppobs_on_user_id"
  end

  create_table "provinces", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "kode"
    t.integer "displays"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sampah_details", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "order_sampah_id", null: false
    t.bigint "sampah_id", null: false
    t.float "harga"
    t.float "qty"
    t.string "satuan"
    t.float "sub_total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_sampah_id"], name: "index_sampah_details_on_order_sampah_id"
    t.index ["sampah_id"], name: "index_sampah_details_on_sampah_id"
  end

  create_table "sampahs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "uuid"
    t.bigint "tipe_sampah_id", null: false
    t.bigint "banksampah_id", null: false
    t.float "harga_kg"
    t.float "harga_satuan"
    t.string "description"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["banksampah_id"], name: "index_sampahs_on_banksampah_id"
    t.index ["tipe_sampah_id"], name: "index_sampahs_on_tipe_sampah_id"
  end

  create_table "server_responses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "body"
    t.text "headers"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipe_sampahs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "harga"
    t.boolean "active"
  end

  create_table "transactions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.integer "user_id"
    t.integer "box_id"
    t.integer "mitra_id"
    t.float "mitra_amount"
    t.float "user_amount"
    t.float "harga"
    t.boolean "diterima"
    t.string "status", default: "in"
    t.integer "botol_id"
    t.string "gambar"
    t.string "phash"
  end

  create_table "user_banks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "kodeBank"
    t.string "nama_bank"
    t.string "nama"
    t.string "rekening"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_valid"
    t.index ["user_id"], name: "index_user_banks_on_user_id"
  end

  create_table "user_vas", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "kodeBank"
    t.string "rekening"
    t.string "name"
    t.datetime "expired"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "fee"
    t.boolean "active"
    t.string "bank_name"
    t.index ["user_id"], name: "index_user_vas_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid"
    t.string "name"
    t.boolean "active"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.string "username"
    t.integer "active_code"
    t.integer "partner_id"
    t.string "google_id", limit: 45
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "usertransactions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.float "credit", default: 0.0
    t.float "debit", default: 0.0
    t.float "balance", default: 0.0
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_usertransactions_on_user_id"
  end

  create_table "vouchers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "outlet_id", null: false
    t.integer "code"
    t.integer "days"
    t.string "status"
    t.date "avai_start"
    t.date "avai_end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["outlet_id"], name: "index_vouchers_on_outlet_id"
  end

  create_table "withdrawls", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "usertransaction_id"
    t.float "amount"
    t.string "status"
    t.string "kodeBank"
    t.string "rekening"
    t.string "nama"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "mitra_id"
    t.integer "mitratransaction_id"
    t.index ["user_id"], name: "index_withdrawls_on_user_id"
    t.index ["usertransaction_id"], name: "index_withdrawls_on_usertransaction_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "alamat_jemputs", "users"
  add_foreign_key "banksampahs", "cities"
  add_foreign_key "banksampahs", "districts"
  add_foreign_key "banksampahs", "provinces"
  add_foreign_key "botol_hargas", "botols"
  add_foreign_key "botol_hargas", "boxes"
  add_foreign_key "bsi_transactions", "banksampahs"
  add_foreign_key "bsi_vas", "banksampahs"
  add_foreign_key "bukti_pembayarans", "admins"
  add_foreign_key "bukti_pembayarans", "mitras"
  add_foreign_key "cities", "provinces"
  add_foreign_key "districts", "cities"
  add_foreign_key "districts", "provinces"
  add_foreign_key "harga_sampahs", "banksampahs"
  add_foreign_key "harga_sampahs", "tipe_sampahs"
  add_foreign_key "histories", "users"
  add_foreign_key "jemputan_details", "jemputans"
  add_foreign_key "jemputan_details", "tipe_sampahs"
  add_foreign_key "jemputans", "alamat_jemputs"
  add_foreign_key "jemputans", "jam_jemputs"
  add_foreign_key "jemputans", "users"
  add_foreign_key "kycs", "cities"
  add_foreign_key "kycs", "districts"
  add_foreign_key "kycs", "mitras"
  add_foreign_key "kycs", "provinces"
  add_foreign_key "mitra_banks", "mitras"
  add_foreign_key "mitra_vas", "mitras"
  add_foreign_key "mitratransactions", "mitras"
  add_foreign_key "mountpays", "mitras"
  add_foreign_key "mountpays", "users"
  add_foreign_key "order_details", "order_sampahs"
  add_foreign_key "order_details", "tipe_sampahs", column: "sampah_id"
  add_foreign_key "order_sampahs", "banksampahs"
  add_foreign_key "order_sampahs", "users"
  add_foreign_key "orders", "boxes"
  add_foreign_key "orders", "users"
  add_foreign_key "ppobs", "users"
  add_foreign_key "sampah_details", "order_sampahs"
  add_foreign_key "sampah_details", "sampahs"
  add_foreign_key "sampahs", "banksampahs"
  add_foreign_key "sampahs", "tipe_sampahs"
  add_foreign_key "user_banks", "users"
  add_foreign_key "user_vas", "users"
  add_foreign_key "usertransactions", "users"
  add_foreign_key "vouchers", "outlets"
  add_foreign_key "withdrawls", "users"
  add_foreign_key "withdrawls", "usertransactions"
end
