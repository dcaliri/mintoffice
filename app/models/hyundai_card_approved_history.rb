class HyundaiCardApprovedHistory < ActiveRecord::Base  
  belongs_to :creditcard
  has_one :card_history, as: :approved
  
  include SpreadsheetParsable
  include SpreadsheetParsable::CardApprovedSources::Hyundai

  def self.excel_parser(type)
    hyundai_card_approved_sources_parser
  end

  def self.preview_stylesheet(upload)
    super("none", upload) do |_, query, params|
      self.new(params)
    end
  end

  def self.create_with_stylesheet(name)
    super("none", name) do |_, query, params|

      collections = where(query)
      if collections.empty?
        collections.create!(params)
      else
        resource = collections.first
        resource.update_attributes!(params)
      end
    end
  end
end