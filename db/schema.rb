# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20160229141815) do

  create_table "activity_logs", :force => true do |t|
    t.string   "netid"
    t.string   "browser"
    t.string   "ip_address"
    t.string   "controller"
    t.string   "action"
    t.text     "params"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "communications", :force => true do |t|
    t.string   "znumber",             :limit => 50
    t.string   "netid",               :limit => 50
    t.integer  "contactByEmail"
    t.integer  "contactByPhone"
    t.string   "contactMobileNumber", :limit => 50
    t.datetime "created_at"
  end

  create_table "communities", :force => true do |t|
    t.string   "znumber",    :limit => 50
    t.string   "netid",      :limit => 50
    t.string   "join_lc",    :limit => 50
    t.string   "lc_choice",  :limit => 50
    t.string   "cclc_type",  :limit => 50
    t.integer  "isSigned"
    t.string   "signature"
    t.datetime "created_at"
  end

  create_table "declines", :force => true do |t|
    t.string   "znumber",    :limit => 50
    t.string   "netid",      :limit => 50
    t.string   "reason",     :limit => 50
    t.datetime "created_at"
  end

  create_table "ftic_modules_availables", :force => true do |t|
    t.string   "znumber"
    t.string   "netid"
    t.string   "f_name"
    t.string   "l_name"
    t.string   "current_step"
    t.integer  "isInternational"
    t.integer  "welcome"
    t.integer  "verify"
    t.integer  "verifybypass"
    t.integer  "deposit"
    t.integer  "depositbypass"
    t.integer  "account"
    t.integer  "accountbypass"
    t.integer  "communication"
    t.integer  "communicationbypass"
    t.integer  "immunization"
    t.integer  "immunizationbypass"
    t.integer  "finaid"
    t.integer  "finaidbypass"
    t.integer  "housingfee"
    t.integer  "housingfeebypass"
    t.integer  "residency"
    t.integer  "residencybypass"
    t.integer  "housingmealplan"
    t.integer  "housingmealplanbypass"
    t.integer  "aleks"
    t.integer  "aleksbypass"
    t.integer  "oars"
    t.integer  "oarsbypass"
    t.integer  "learning_comm"
    t.integer  "learning_commbypass"
    t.integer  "orientation"
    t.integer  "orientationbypass"
    t.integer  "registration"
    t.integer  "registrationbypass"
    t.integer  "emergency"
    t.integer  "emergencybypass"
    t.integer  "faualert"
    t.integer  "faualertbypass"
    t.integer  "owlcard"
    t.integer  "owlcardbypass"
    t.integer  "bookadvance"
    t.integer  "bookadvancebypass"
    t.integer  "tution"
    t.integer  "tuitionbypass"
    t.integer  "vehiclereg"
    t.integer  "vehicleregbypass"
    t.integer  "congrats"
    t.integer  "intl_medical"
    t.integer  "intl_medical_bypass"
    t.integer  "intl_visa"
    t.integer  "intl_visa_bypass"
    t.integer  "intl_orientation"
    t.integer  "intl_orientation_bypass"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "isactive"
  end

  create_table "ftic_modules_availables_bak", :force => true do |t|
    t.string   "znumber"
    t.string   "netid"
    t.string   "f_name"
    t.string   "l_name"
    t.integer  "isInternational"
    t.integer  "welcome"
    t.integer  "verify",                  :default => 1
    t.integer  "verifybypass",            :default => 0
    t.integer  "deposit"
    t.integer  "depositbypass",           :default => 0
    t.integer  "account"
    t.integer  "accountbypass",           :default => 0
    t.integer  "communication"
    t.integer  "communicationbypass",     :default => 0
    t.integer  "immunization"
    t.integer  "immunizationbypass",      :default => 0
    t.integer  "finaid"
    t.integer  "finaidbypass",            :default => 0
    t.integer  "housingfee"
    t.integer  "housingfeebypass",        :default => 0
    t.integer  "residency"
    t.integer  "residencybypass",         :default => 0
    t.integer  "housingmealplan"
    t.integer  "housingmealplanbypass",   :default => 0
    t.integer  "aleks"
    t.integer  "aleksbypass",             :default => 0
    t.integer  "oars"
    t.integer  "oarsbypass",              :default => 0
    t.integer  "learning_comm"
    t.integer  "learning_commbypass",     :default => 0
    t.integer  "orientation"
    t.integer  "orientationbypass",       :default => 0
    t.integer  "registration"
    t.integer  "registrationbypass",      :default => 0
    t.integer  "emergency"
    t.integer  "emergencybypass",         :default => 0
    t.integer  "faualert"
    t.integer  "faualertbypass",          :default => 0
    t.integer  "owlcard"
    t.integer  "owlcardbypass",           :default => 0
    t.integer  "bookadvance"
    t.integer  "bookadvancebypass",       :default => 0
    t.integer  "tution"
    t.integer  "tuitionbypass",           :default => 0
    t.integer  "vehiclereg"
    t.integer  "vehicleregbypass",        :default => 0
    t.integer  "congrats",                :default => 0
    t.integer  "intl_medical",            :default => 0
    t.integer  "intl_medical_bypass",     :default => 0
    t.integer  "intl_visa",               :default => 0
    t.integer  "intl_visa_bypass",        :default => 0
    t.integer  "intl_orientation",        :default => 0
    t.integer  "intl_orientation_bypass", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "isactive"
  end

  create_table "housing_zipcodes", :force => true do |t|
    t.integer  "zip"
    t.text     "city"
    t.text     "state"
    t.text     "county"
    t.text     "campus"
    t.float    "distance",   :limit => 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.string   "to"
    t.string   "from"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "netid"
    t.integer  "module_id"
    t.string   "module"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "verifies", :force => true do |t|
    t.string   "znumber",     :limit => 50
    t.string   "netid",       :limit => 50
    t.string   "verify_info", :limit => 50
    t.datetime "created_at"
  end

end
