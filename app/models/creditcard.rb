#encoding: UTF-8

class Creditcard < ActiveRecord::Base
  has_many :cardbills
  has_many :card_used_sources
  has_many :card_approved_sources
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
    :card_used_sources,
    :card_used_sources_hyundai,
    :card_approved_sources,
    :card_approved_sources_hyundai,
    :card_approved_sources_oversea
  ]
  CARD_LIST_FOR_SELECT = [[I18n.t('models.creditcard.used_detail'), CARD_LIST[0]],
                         [I18n.t('models.creditcard.used_hyundai_detail'), CARD_LIST[1]],
                         [I18n.t('models.creditcard.approved_detail'), CARD_LIST[2]],
                         [I18n.t('models.creditcard.approved_hyundai'), CARD_LIST[3]],
                         [I18n.t('models.creditcard.foreign_detail'), CARD_LIST[4]],]

  include SpreadsheetParsable
  include SpreadsheetParsable::CardUsedSourcesInfo
  include SpreadsheetParsable::CardUsedSourcesHyundaiInfo
  include SpreadsheetParsable::CardApprovedSourcesInfo
  include SpreadsheetParsable::CardApprovedSourcesHyundaiInfo
  include SpreadsheetParsable::CardApprovedSourcesOverseaInfo

  def self.excel_parser(type)
    if type == :card_used_sources
      used_sources_parser
    elsif type == :card_used_sources_hyundai
      hyundai_used_sources_parser
    elsif type == :card_approved_sources
      approved_sources_parser
    elsif type == :card_approved_sources_oversea
      approved_sources_oversea_parser
    elsif type == :card_approved_sources_hyundai
      approved_sources_hyundai_parser
    else
      raise "형식을 알 수 없습니다. type = #{type}"
    end
  end

  def self.preview_stylesheet(type, upload)
    raise ArgumentError, I18n.t('common.upload.empty') unless upload
    path = file_path(upload['file'].original_filename)
    parser = excel_parser(type.to_sym)

    create_file(path, upload['file'])
    parser.preview(path)
  end

  def self.create_with_stylesheet(type, name)
    path = file_path(name)
    parser = excel_parser(type.to_sym)

    parser.parse(path) do |class_name, query, params|
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
    File.delete(path)
  end

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
end
