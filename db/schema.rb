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

ActiveRecord::Schema.define(:version => 20120410052455) do

  create_table "attachments", :force => true do |t|
    t.string   "title"
    t.string   "comments"
    t.string   "filepath"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "user_id",           :default => 0,  :null => false
    t.string   "contenttype",       :default => "", :null => false
    t.string   "owner_table_name"
    t.integer  "owner_id"
    t.string   "original_filename"
    t.integer  "seq"
  end

  create_table "business_clients", :force => true do |t|
    t.string   "name"
    t.string   "registration_number"
    t.string   "category"
    t.string   "condition"
    t.string   "address"
    t.string   "owner"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "attachment_id"
  end

  create_table "cardbills", :force => true do |t|
    t.string   "cardno"
    t.datetime "transdate"
    t.decimal  "amount"
    t.decimal  "vat"
    t.decimal  "servicecharge"
    t.decimal  "totalamount"
    t.string   "storename"
    t.string   "storeaddr"
    t.string   "approveno"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "attachment_id"
    t.integer  "creditcard_id"
  end

  create_table "creditcards", :force => true do |t|
    t.string   "cardno"
    t.string   "expireyear"
    t.string   "expiremonth"
    t.string   "nickname"
    t.string   "issuer"
    t.string   "cardholder"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "document_owners", :force => true do |t|
    t.integer  "document_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "documents", :force => true do |t|
    t.string   "title"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "documents_tags", :id => false, :force => true do |t|
    t.integer "document_id"
    t.integer "tag_id"
  end

  add_index "documents_tags", ["document_id", "tag_id"], :name => "index_documents_tags_on_document_id_and_tag_id", :unique => true

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "hrinfo_histories", :force => true do |t|
    t.integer  "hrinfo_id"
    t.string   "change"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "hrinfos", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "picture_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.date     "joined_on"
    t.date     "retired_on"
    t.integer  "user_id"
    t.string   "address"
    t.string   "email"
    t.string   "mphone"
    t.string   "position"
    t.integer  "companyno"
    t.string   "juminno"
  end

  add_index "hrinfos", ["companyno"], :name => "index_hrinfos_on_companyno", :unique => true

  create_table "namecards", :force => true do |t|
    t.string   "name"
    t.string   "jobtitle"
    t.string   "department"
    t.string   "company"
    t.string   "phone"
    t.string   "homepage"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pay_schedules", :force => true do |t|
    t.integer  "user_id"
    t.date     "payday"
    t.decimal  "amount"
    t.string   "category"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "permissions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "permissions_users", :id => false, :force => true do |t|
    t.integer "permission_id"
    t.integer "user_id"
  end

  add_index "permissions_users", ["permission_id", "user_id"], :name => "index_permissions_users_on_permission_id_and_user_id", :unique => true

  create_table "pettycashes", :force => true do |t|
    t.datetime "transdate"
    t.decimal  "inmoney",       :default => 0.0, :null => false
    t.decimal  "outmoney",      :default => 0.0, :null => false
    t.text     "description"
    t.integer  "attachment_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "projects", :force => true do |t|
    t.text     "name"
    t.date     "started_on"
    t.date     "ending_on"
    t.date     "ended_on"
    t.decimal  "revenue",    :precision => 20, :scale => 0
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "projects_users", :id => false, :force => true do |t|
    t.integer "project_id"
    t.integer "user_id"
  end

  create_table "required_tags", :force => true do |t|
    t.string   "modelname"
    t.integer  "tag_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "taxbill_items", :force => true do |t|
    t.datetime "transacted_at"
    t.text     "note"
    t.decimal  "unitprice",     :default => 0.0, :null => false
    t.integer  "quantity"
    t.decimal  "price",         :default => 0.0, :null => false
    t.decimal  "tax",           :default => 0.0, :null => false
    t.decimal  "sumvalue",      :default => 0.0, :null => false
    t.integer  "taxbill_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "taxbills", :force => true do |t|
    t.string   "billtype"
    t.datetime "transacted_at"
    t.integer  "taxman_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "taxmen", :force => true do |t|
    t.integer  "business_client_id"
    t.string   "fullname"
    t.string   "email"
    t.string   "phonenumber"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
