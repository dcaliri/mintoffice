class AddInformationOfTaxbillItems < ActiveRecord::Migration
  def change
    add_column :taxbill_items, :uid, :integer
    add_column :taxbill_items, :written_at, :date
    add_column :taxbill_items, :approve_no, :string
    add_column :taxbill_items, :transmit_at, :date
    add_column :taxbill_items, :seller_registration_number, :string
    add_column :taxbill_items, :sellers_minor_place_registration_number, :string
    add_column :taxbill_items, :sellers_company_name, :string
    add_column :taxbill_items, :sellers_representative, :string
    add_column :taxbill_items, :buyer_registration_number, :string
    add_column :taxbill_items, :buyers_minor_place_registration_number, :string
    add_column :taxbill_items, :buyers_company_name, :string
    add_column :taxbill_items, :buyerss_representative, :string
    add_column :taxbill_items, :supplied_value, :decimal
    add_column :taxbill_items, :taxbill_classification, :string
    add_column :taxbill_items, :taxbill_type, :string
    add_column :taxbill_items, :issue_type, :string
    add_column :taxbill_items, :etc, :string
    add_column :taxbill_items, :bill_action_type, :string
    add_column :taxbill_items, :seller_email, :string
    add_column :taxbill_items, :buyer1_email, :string
    add_column :taxbill_items, :buyer2_email, :string
    add_column :taxbill_items, :item_date, :date
    add_column :taxbill_items, :item_name, :string
    add_column :taxbill_items, :item_standard, :string
    add_column :taxbill_items, :item_supply_price, :decimal
    add_column :taxbill_items, :item_tax, :decimal
    add_column :taxbill_items, :item_note, :string
  end
end