class CardApprovedSource < ActiveRecord::Base
  belongs_to :creditcard
  include StylesheetParseable

  self.per_page = 20

  set_parser_columns [
    :used_at,
    :approve_no,
    :card_no,
    :card_holder_name,
    :store_name,
    :money,
    :used_type,
    :monthly_duration,
    :card_type,
    :canceled_at,
    :status,
    :will_be_paied_at
  ]
  set_parser_keys [
    :approve_no
  ]

  def self.latest
    order("used_at DESC")
  end
end