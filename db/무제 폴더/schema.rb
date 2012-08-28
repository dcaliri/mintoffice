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

ActiveRecord::Schema.define(:version => 20120827054557) do

  create_table "access_people", :force => true do |t|
    t.integer  "access_target_id"
    t.string   "access_target_type"
    t.string   "access_type",        :default => "read"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "provider"
    t.string   "uid"
    t.string   "google_account"
    t.string   "boxcar_account"
    t.string   "notify_email"
    t.string   "api_key"
    t.string   "redmine_account"
    t.string   "daum_account"
    t.string   "nate_account"
    t.integer  "person_id"
  end

  create_table "attachments", :force => true do |t|
    t.string   "title"
    t.string   "comments"
    t.string   "filepath"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "contenttype",       :default => "", :null => false
    t.string   "owner_type"
    t.integer  "owner_id"
    t.string   "original_filename"
    t.integer  "seq"
    t.integer  "employee_id"
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
    t.decimal  "in",                      :default => 0.0
    t.decimal  "out",                     :default => 0.0
    t.text     "note"
    t.decimal  "remain",                  :default => 0.0
    t.string   "branchname"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "out_bank_account"
    t.string   "out_bank_name"
    t.decimal  "promissory_check_amount"
    t.string   "cms_code"
    t.integer  "transact_order"
  end

  create_table "bank_transfers", :force => true do |t|
    t.integer  "bank_account_id"
    t.string   "transfer_type"
    t.datetime "transfered_at"
    t.string   "result"
    t.string   "out_bank_account"
    t.string   "in_bank_name"
    t.string   "in_bank_account"
    t.decimal  "money"
    t.decimal  "transfer_fee"
    t.decimal  "error_money"
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

  create_table "bankbooks", :force => true do |t|
    t.string   "name"
    t.string   "number"
    t.string   "account_holder"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "holder_type"
    t.integer  "holder_id"
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
    t.decimal  "money"
    t.string   "used_type"
    t.string   "monthly_duration"
    t.string   "card_type"
    t.datetime "canceled_at"
    t.string   "status"
    t.date     "will_be_paied_at"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "card_no"
    t.string   "money_foreign"
    t.string   "money_type"
    t.string   "money_type_info"
    t.string   "money_dollar"
    t.string   "money_us"
    t.string   "nation"
    t.string   "nation_statement"
    t.string   "refuse_reason"
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
    t.decimal  "money_krw"
    t.decimal  "money_foreign"
    t.decimal  "price"
    t.decimal  "tax"
    t.decimal  "tip"
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
    t.date     "used_at"
    t.string   "tax_type"
    t.string   "sales_statement"
    t.string   "nation_statement"
    t.string   "prepayment_statement"
    t.date     "accepted_at"
    t.string   "apply_sales_statement"
    t.string   "purchase_statement"
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

  create_table "change_histories", :force => true do |t|
    t.string   "fieldname"
    t.string   "before_value"
    t.string   "after_value"
    t.integer  "changable_id"
    t.string   "changable_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "target"
    t.integer  "employee_id"
  end

  create_table "commutes", :force => true do |t|
    t.datetime "go"
    t.datetime "leave"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "employee_id"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "pay_basic_date",          :default => 20
    t.integer  "payday",                  :default => 25
    t.string   "registration_number"
    t.string   "owner_name"
    t.string   "address"
    t.string   "phone_number"
    t.string   "google_apps_domain"
    t.string   "google_apps_accountname"
    t.string   "google_apps_password"
    t.string   "redmine_domain"
    t.string   "redmine_accountname"
    t.string   "redmine_password"
    t.string   "default_password"
    t.integer  "apply_admin_id"
    t.string   "enrollment_items"
  end

  create_table "companies_people", :id => false, :force => true do |t|
    t.integer "company_id"
    t.integer "person_id"
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
    t.boolean "migrated_data", :default => false
    t.integer "owner_id"
    t.boolean "isprivate",     :default => false
    t.integer "company_id"
    t.string  "google_id"
    t.string  "google_etag"
    t.integer "person_id"
  end

  create_table "creditcards", :force => true do |t|
    t.string   "cardno"
    t.string   "expireyear"
    t.string   "expiremonth"
    t.string   "nickname"
    t.string   "issuer"
    t.string   "cardholder"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "short_name"
    t.integer  "bank_account_id"
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
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "person_id"
  end

  create_table "document_owners", :force => true do |t|
    t.integer  "document_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "employee_id"
  end

  create_table "documents", :force => true do |t|
    t.string   "title"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "company_id"
  end

  create_table "documents_tags", :id => false, :force => true do |t|
    t.integer "document_id"
    t.integer "tag_id"
  end

  add_index "documents_tags", ["document_id", "tag_id"], :name => "index_documents_tags_on_document_id_and_tag_id", :unique => true

  create_table "employees", :force => true do |t|
    t.integer  "picture_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.date     "joined_on"
    t.date     "retired_on"
    t.integer  "companyno"
    t.string   "juminno"
    t.boolean  "listed"
    t.text     "employment_proof_hash"
    t.integer  "person_id"
  end

  add_index "employees", ["companyno"], :name => "index_employees_on_companyno"

  create_table "enrollment_items", :force => true do |t|
    t.string   "name"
    t.integer  "enrollment_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "enrollments", :force => true do |t|
    t.string   "juminno"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "company_id"
    t.integer  "person_id"
  end

  create_table "except_columns", :force => true do |t|
    t.string   "model_name"
    t.string   "key"
    t.text     "columns"
    t.boolean  "default",     :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "employee_id"
  end

  create_table "expense_reports", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "target_id"
    t.string   "target_type"
    t.integer  "project_id"
    t.text     "description"
    t.decimal  "amount"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.date     "expensed_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "parent_id"
  end

  create_table "groups_people", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "person_id"
  end

  add_index "groups_people", ["person_id", "group_id"], :name => "index_groups_people_on_person_id_and_group_id"

  create_table "holidays", :force => true do |t|
    t.date     "theday"
    t.string   "dayname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "investment_estimations", :force => true do |t|
    t.integer  "investment_id"
    t.decimal  "amount"
    t.date     "estimated_at"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "investments", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

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
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "payment_records", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "payments", :force => true do |t|
    t.date     "pay_finish"
    t.decimal  "amount",       :default => 0.0
    t.text     "note"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "payment_type"
    t.date     "pay_start"
    t.integer  "employee_id"
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
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "employee_id"
  end

  create_table "people", :force => true do |t|
  end

  create_table "people_permissions", :id => false, :force => true do |t|
    t.integer "permission_id"
    t.integer "person_id"
  end

  add_index "people_permissions", ["person_id", "permission_id"], :name => "index_people_permissions_on_person_id_and_permission_id"

  create_table "permissions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pettycashes", :force => true do |t|
    t.datetime "transdate"
    t.decimal  "inmoney",       :default => 0.0, :null => false
    t.decimal  "outmoney",      :default => 0.0, :null => false
    t.text     "description"
    t.integer  "attachment_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "posting_items", :force => true do |t|
    t.integer  "posting_id"
    t.integer  "ledger_account_id"
    t.integer  "item_type"
    t.decimal  "amount"
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
    t.integer  "project_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "employee_id"
    t.boolean  "owner",       :default => false
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
    t.decimal  "revenue",    :precision => 20, :scale => 1, :default => 0.0
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
    t.integer  "company_id"
  end

  create_table "promissories", :force => true do |t|
    t.date     "expired_at"
    t.date     "published_at"
    t.decimal  "amount"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "report_comments", :force => true do |t|
    t.integer  "report_id"
    t.integer  "owner_id"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "report_people", :force => true do |t|
    t.integer  "report_id"
    t.integer  "prev_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "owner",      :default => false
    t.integer  "person_id"
  end

  create_table "reports", :force => true do |t|
    t.integer "target_id"
    t.string  "target_type"
    t.string  "status"
  end

  create_table "required_tags", :force => true do |t|
    t.string   "modelname"
    t.integer  "tag_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "company_id"
  end

  create_table "taxbill_items", :force => true do |t|
    t.datetime "transacted_at"
    t.text     "note"
    t.decimal  "unitprice",                               :default => 0.0, :null => false
    t.integer  "quantity",                                :default => 1
    t.decimal  "total",                                   :default => 0.0, :null => false
    t.decimal  "tax",                                     :default => 0.0, :null => false
    t.integer  "taxbill_id"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.integer  "uid"
    t.date     "written_at"
    t.string   "approve_no"
    t.date     "transmit_at"
    t.string   "seller_registration_number"
    t.string   "sellers_minor_place_registration_number"
    t.string   "sellers_company_name"
    t.string   "sellers_representative"
    t.string   "buyer_registration_number"
    t.string   "buyers_minor_place_registration_number"
    t.string   "buyers_company_name"
    t.string   "buyerss_representative"
    t.decimal  "supplied_value"
    t.string   "taxbill_classification"
    t.string   "taxbill_type"
    t.string   "issue_type"
    t.string   "etc"
    t.string   "bill_action_type"
    t.string   "seller_email"
    t.string   "buyer1_email"
    t.string   "buyer2_email"
    t.date     "item_date"
    t.string   "item_name"
    t.string   "item_standard"
    t.decimal  "item_supply_price"
    t.decimal  "item_tax"
    t.string   "item_note"
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
    t.integer  "person_id"
  end

  create_table "used_vacations", :force => true do |t|
    t.integer  "vacation_id"
    t.date     "from"
    t.date     "to"
    t.text     "note"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.decimal  "period"
  end

  create_table "vacation_type_infos", :force => true do |t|
    t.integer  "used_vacation_id"
    t.integer  "vacation_type_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "vacation_types", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "vacations", :force => true do |t|
    t.date     "from"
    t.date     "to"
    t.decimal  "period"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "employee_id"
  end

end
