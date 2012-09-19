#encoding: UTF-8

class Creditcard < ActiveRecord::Base
  has_many :cardbills
  has_many :card_used_sources
  has_many :card_approved_sources
  has_many :card_histories
  belongs_to :bank_account

  validates_presence_of :cardno
  validates_presence_of :expireyear
  validates_presence_of :expiremonth
  validates_presence_of :nickname
  validates_presence_of :issuer
  validates_presence_of :cardholder
  validates_uniqueness_of :cardno

  include Historiable
  include Attachmentable

  CARD_LIST = [
    :default_card_used_sources,
    :hyundai_card_used_sources,
    :default_card_approved_sources,
    :hyundai_card_approved_sources,
    :oversea_card_approved_sources
  ]

  CARD_LIST_FOR_SELECT = [[I18n.t('models.creditcard.used_detail'), CARD_LIST[0]],
                         [I18n.t('models.creditcard.used_hyundai_detail'), CARD_LIST[1]],
                         [I18n.t('models.creditcard.approved_detail'), CARD_LIST[2]],
                         [I18n.t('models.creditcard.approved_hyundai'), CARD_LIST[3]],
                         [I18n.t('models.creditcard.foreign_detail'), CARD_LIST[4]],]

  def cardno_long
    if self.nickname == nil
      self.cardno
    else
     self.cardno + " (" + self.nickname + ")"
   end
  end

  class << self
    def approved_per_period(query)
      collection = CardApprovedSource.where('will_be_paied_at IS NOT NULL').order(query)
      if collection.empty?
        Time.zone.now
      else
        collection.first.will_be_paied_at
      end
    end

    def newest_approved_source
      approved_per_period('will_be_paied_at DESC')
    end

    def oldest_approved_source
      approved_per_period('will_be_paied_at ASC') - 1.month
    end
  end

  ## Excel Parser ######################################
  include SpreadsheetParsable
  include SpreadsheetParsable::CardUsedSources::Default
  include SpreadsheetParsable::CardUsedSources::Hyundai
  include SpreadsheetParsable::CardApprovedSources::Default
  include SpreadsheetParsable::CardApprovedSources::Hyundai
  include SpreadsheetParsable::CardApprovedSources::Oversea

  def self.excel_parser(type)
    parser_name = "#{type}_parser"
    send(parser_name)
  end

  def self.preview_stylesheet(type, upload)
    super(type, upload) do |class_name, query, params|
      class_name.new(params)
    end
  end

  def self.create_with_stylesheet(type, name)
    super(type, name) do |class_name, query, params|
      creditcards = Creditcard.where(:short_name => params[:card_no])

      unless creditcards.empty?
        creditcard = creditcards.first
        collections = creditcard.send(class_name.to_s.tableize).where(query)
        if collections.empty?
          collections.create!(params)
        else
          resource = collections.first
          resource.update_attributes!(params)
        end
      end
    end
  end
end
