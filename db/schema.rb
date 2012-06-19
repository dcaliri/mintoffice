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

ActiveRecord::Schema.define(:version => 20120607053901) do

  create_table "access_people", :force => true do |t|
    t.integer  "user_id"
    t.integer  "access_target_id"
    t.string   "access_target_type"
    t.string   "access_type",        :default => "read"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "attachments", :force => true do |t|
    t.string   "title"
    t.string   "comments"
    t.string   "filepath"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",           :default => 0,  :null => false
    t.string   "contenttype",       :default => "", :null => false
    t.string   "owner_type"
    t.integer  "owner_id"
    t.string   "original_filename"
    t.integer  "seq"
  end

  create_table "bank_accounts", :force => true do |t|
    t.string "name"
    t.string "number"
    t.text   "note"
  end

  create_table "bank_transactions", :force => true do |t|
    t.integer  "bank_account_id"
    t.datetime "transacted_at"
    t.string   "transaction_type"
    t.integer  "in",                      :default => 0
    t.integer  "out",                     :default => 0
    t.text     "note"
    t.integer  "remain",                  :default => 0
    t.string   "branchname"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "out_bank_account"
    t.string   "out_bank_name"
    t.integer  "promissory_check_amount"
    t.string   "cms_code"
  end

  create_table "bank_transfers", :force => true do |t|
    t.integer  "bank_account_id"
    t.string   "transfer_type"
    t.datetime "transfered_at"
    t.string   "result"
    t.string   "out_bank_account"
    t.string   "in_bank_name"
    t.string   "in_bank_account"
    t.integer  "money"
    t.integer  "transfer_fee"
    t.integer  "error_money"
    t.datetime "registered_at"
    t.string   "error_code"
    t.string   "transfer_note"
    t.string   "incode"
    t.string   "out_account_note"
    t.string   "in_account_note"
    t.string   "in_person_name"
    t.string   "cms_code"
    t.string   "currency_code"
  end

  create_table "business_clients", :force => true do |t|
    t.string   "name"
    t.string   "registration_number"
    t.string   "category"
    t.string   "business_status"
    t.string   "address"
    t.string   "owner"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "attachment_id"
    t.integer  "company_id"
  end

  create_table "card_approved_sources", :force => true do |t|
    t.integer  "creditcard_id"
    t.datetime "used_at"
    t.string   "approve_no"
    t.string   "card_holder_name"
    t.string   "store_name"
    t.integer  "money"
    t.string   "used_type"
    t.string   "monthly_duration"
    t.string   "card_type"
    t.datetime "canceled_at"
    t.string   "status"
    t.datetime "will_be_paied_at"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "card_no"
    t.string   "money_foreign"
    t.string   "money_type"
    t.string   "money_type_info"
    t.string   "money_dollar"
  end

  create_table "card_used_sources", :force => true do |t|
    t.integer  "creditcard_id"
    t.string   "card_no"
    t.string   "bank_account"
    t.string   "bank_name"
    t.string   "card_holder_name"
    t.string   "used_area"
    t.string   "approve_no"
    t.datetime "approved_at"
    t.datetime "approved_time"
    t.string   "sales_type"
    t.integer  "money_krw"
    t.integer  "money_foreign"
    t.integer  "price"
    t.integer  "tax"
    t.integer  "tip"
    t.string   "monthly_duration"
    t.string   "exchange_krw"
    t.string   "foreign_country_code"
    t.string   "foreign_country_name"
    t.string   "store_business_no"
    t.string   "store_name"
    t.string   "store_type"
    t.string   "store_zipcode"
    t.string   "store_addr1"
    t.string   "store_addr2"
    t.string   "store_tel"
  end

  create_table "cardbills", :force => true do |t|
    t.string   "cardno"
    t.datetime "transdate"
    t.decimal  "amount",        :precision => 10, :scale => 0
    t.decimal  "vat",           :precision => 10, :scale => 0
    t.decimal  "servicecharge", :precision => 10, :scale => 0
    t.decimal  "totalamount",   :precision => 10, :scale => 0
    t.string   "storename"
    t.string   "storeaddr"
    t.string   "approveno"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "attachment_id"
    t.integer  "creditcard_id"
    t.boolean  "before_report"
  end

  create_table "change_histories", :force => true do |t|
    t.string   "fieldname"
    t.string   "before_value"
    t.string   "after_value"
    t.integer  "user_id"
    t.integer  "changable_id"
    t.string   "changable_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "target"
  end

  create_table "commutes", :force => true do |t|
    t.datetime "go"
    t.datetime "leave"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "pay_basic_date",      :default => 20
    t.integer  "payday",              :default => 25
    t.string   "registration_number"
    t.string   "owner_name"
    t.string   "address"
    t.string   "phone_number"
  end

  create_table "contact_address_tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "company_id"
  end

  create_table "contact_address_tags_contact_addresses", :id => false, :force => true do |t|
    t.integer "contact_address_tag_id"
    t.integer "contact_address_id"
  end

  create_table "contact_addresses", :force => true do |t|
    t.integer  "contact_id"
    t.string   "target"
    t.string   "country"
    t.string   "province"
    t.string   "city"
    t.string   "other1"
    t.string   "other2"
    t.string   "postal_code"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "contact_email_tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "company_id"
  end

  create_table "contact_email_tags_contact_emails", :id => false, :force => true do |t|
    t.integer "contact_email_tag_id"
    t.integer "contact_email_id"
  end

  create_table "contact_emails", :force => true do |t|
    t.integer "contact_id"
    t.string  "target"
    t.string  "email"
  end

  create_table "contact_other_tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "company_id"
  end

  create_table "contact_other_tags_contact_others", :id => false, :force => true do |t|
    t.integer "contact_other_tag_id"
    t.integer "contact_other_id"
  end

  create_table "contact_others", :force => true do |t|
    t.integer  "contact_id"
    t.string   "target"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "contact_phone_number_tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "company_id"
  end

  create_table "contact_phone_number_tags_contact_phone_numbers", :id => false, :force => true do |t|
    t.integer "contact_phone_number_tag_id"
    t.integer "contact_phone_number_id"
  end

  create_table "contact_phone_numbers", :force => true do |t|
    t.integer "contact_id"
    t.string  "target"
    t.string  "number"
  end

  create_table "contacts", :force => true do |t|
    t.string  "firstname"
    t.string  "lastname"
    t.string  "company_name"
    t.string  "department"
    t.string  "position"
    t.text    "email_list"
    t.integer "target_id"
    t.string  "target_type"
    t.boolean "migrated_data", :default => false
    t.integer "owner_id"
    t.boolean "isprivate",     :default => false
    t.integer "company_id"
  end

  create_table "creditcards", :force => true do |t|
    t.string   "cardno"
    t.string   "expireyear"
    t.string   "expiremonth"
    t.string   "nickname"
    t.string   "issuer"
    t.string   "cardholder"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_name"
  end

  create_table "dayworker_taxes", :force => true do |t|
    t.integer  "dayworker_id"
    t.date     "apply_day"
    t.string   "reason"
    t.decimal  "amount",       :precision => 10, :scale => 2
    t.decimal  "tax_amount",   :precision => 10, :scale => 2
    t.decimal  "pay_amount",   :precision => 10, :scale => 2
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "dayworkers", :force => true do |t|
    t.string   "juminno"
    t.integer  "contact_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "document_owners", :force => true do |t|
    t.integer  "document_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", :force => true do |t|
    t.string   "title"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  create_table "documents_tags", :id => false, :force => true do |t|
    t.integer "document_id"
    t.integer "tag_id"
  end

  add_index "documents_tags", ["document_id", "tag_id"], :name => "index_documents_tags_on_document_id_and_tag_id", :unique => true

  create_table "expense_reports", :force => true do |t|
    t.integer  "hrinfo_id"
    t.integer  "target_id"
    t.string   "target_type"
    t.integer  "project_id"
    t.text     "description"
    t.integer  "amount"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.date     "expensed_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "holidays", :force => true do |t|
    t.date     "theday"
    t.string   "dayname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "hrinfo_histories", :force => true do |t|
    t.integer  "hrinfo_id"
    t.string   "change"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hrinfos", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "picture_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "joined_on"
    t.date     "retired_on"
    t.integer  "user_id"
    t.string   "position"
    t.integer  "companyno"
    t.string   "juminno"
    t.boolean  "listed"
    t.string   "department"
    t.text     "employment_proof_hash"
  end

  add_index "hrinfos", ["companyno"], :name => "index_hrinfos_on_companyno", :unique => true

  create_table "ledger_accounts", :force => true do |t|
    t.string   "title"
    t.integer  "category"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "namecards", :force => true do |t|
    t.string   "name"
    t.string   "jobtitle"
    t.string   "department"
    t.string   "company"
    t.string   "phone"
    t.string   "homepage"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.date     "pay_finish"
    t.decimal  "amount",       :precision => 10, :scale => 0, :default => 0
    t.text     "note"
    t.integer  "user_id"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
    t.string   "payment_type"
    t.date     "pay_start"
  end

  create_table "payroll_categories", :force => true do |t|
    t.integer  "prtype"
    t.integer  "code"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "payroll_items", :force => true do |t|
    t.integer  "payroll_id"
    t.integer  "payroll_category_id"
    t.decimal  "amount",              :precision => 10, :scale => 2
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

  create_table "payrolls", :force => true do |t|
    t.date     "payday"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "permissions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions_users", :id => false, :force => true do |t|
    t.integer "permission_id"
    t.integer "user_id"
  end

  add_index "permissions_users", ["permission_id", "user_id"], :name => "index_permissions_users_on_permission_id_and_user_id", :unique => true

  create_table "pettycashes", :force => true do |t|
    t.datetime "transdate"
    t.decimal  "inmoney",       :precision => 10, :scale => 0, :default => 0, :null => false
    t.decimal  "outmoney",      :precision => 10, :scale => 0, :default => 0, :null => false
    t.text     "description"
    t.integer  "attachment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posting_items", :force => true do |t|
    t.integer  "posting_id"
    t.integer  "ledger_account_id"
    t.integer  "item_type"
    t.integer  "amount"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "postings", :force => true do |t|
    t.date     "posted_at"
    t.text     "description"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "expense_report_id"
  end

  create_table "project_assign_infos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "project_assign_rates", :force => true do |t|
    t.integer "project_assign_info_id"
    t.date    "start"
    t.date    "finish"
    t.integer "percentage"
  end

  create_table "projects", :force => true do |t|
    t.text     "name"
    t.date     "started_on"
    t.date     "ending_on"
    t.date     "ended_on"
    t.decimal  "revenue",    :precision => 20, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  create_table "report_comments", :force => true do |t|
    t.integer  "report_id"
    t.integer  "owner_id"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "report_people", :force => true do |t|
    t.integer  "user_id"
    t.integer  "report_id"
    t.integer  "prev_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "permission_type", :default => "read"
    t.boolean  "owner",           :default => false
  end

  create_table "reports", :force => true do |t|
    t.integer "target_id"
    t.string  "target_type"
    t.string  "status"
  end

  create_table "required_tags", :force => true do |t|
    t.string   "modelname"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.string   "name"
    t.integer  "target_id"
    t.string   "target_type"
    t.integer  "tag_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  create_table "taxbill_items", :force => true do |t|
    t.datetime "transacted_at"
    t.text     "note"
    t.decimal  "unitprice",     :precision => 10, :scale => 0, :default => 0, :null => false
    t.integer  "quantity",                                     :default => 1
    t.decimal  "total",         :precision => 10, :scale => 0, :default => 0, :null => false
    t.decimal  "tax",           :precision => 10, :scale => 0, :default => 0, :null => false
    t.integer  "taxbill_id"
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
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

  create_table "used_vacations", :force => true do |t|
    t.integer  "vacation_id"
    t.date     "from"
    t.date     "to"
    t.text     "note"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.decimal  "period",      :precision => 10, :scale => 0
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "gmail_account"
    t.string   "boxcar_account"
    t.string   "notify_email"
    t.string   "api_key"
  end

  create_table "vacations", :force => true do |t|
    t.integer  "user_id"
    t.date     "from"
    t.date     "to"
    t.decimal  "period",     :precision => 10, :scale => 0
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

end
