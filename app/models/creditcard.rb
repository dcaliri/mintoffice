#encoding: UTF-8

class Creditcard < ActiveRecord::Base
  has_many :cardbills
  has_many :card_used_sources
  has_many :card_approved_sources

  validates_presence_of :cardno
  validates_presence_of :expireyear
  validates_presence_of :expiremonth
  validates_presence_of :nickname
  validates_presence_of :issuer
  validates_presence_of :cardholder
  validates_uniqueness_of :cardno

  include Historiable

  CARD_LIST = [:card_used_sources, :card_approved_sources, :card_approved_sources_oversea]
  CARD_LIST_FOR_SELECT = [["이용내역", CARD_LIST[0]],["승인내역", CARD_LIST[1]], ["해외승인내역", CARD_LIST[2]]]

  include NewStylesheetParsable
  include Excels::CardUsedSourcesInfo
  include Excels::CardApprovedSourcesInfo
  include Excels::CardApprovedSourcesOverseaInfo

  def self.preview_stylesheet(type, upload)
    path = file_path(upload['file'].original_filename)
    create_file(path, upload['file'])
    excel_parser(type.to_sym).preview(parser_class_name(type.to_sym), path)
  end

  def self.create_with_stylesheet(type, name)
    path = file_path(name)
    parse_stylesheet(type.to_sym, path)
    File.delete(path)
  end

  def self.parser_class_name(type)
    if type == :card_used_sources
      CardUsedSource
    else
      CardApprovedSource
    end
  end

  def self.excel_parser(type)
    if type == :card_used_sources
      used_sources_parser
    elsif type == :card_approved_sources
      approved_sources_parser
    else
      approved_sources_oversea_parser
    end
  end

  def self.parse_stylesheet(type, file, opts = {})
    excel_parser(type).parse(file) do |query, params|
      creditcards = Creditcard.where(:short_name => params[:card_no])

      unless creditcards.empty?
        creditcard = creditcards.first
        collections = creditcard.send(parser_class_name(type).to_s.tableize).where(query)
        if collections.empty?
          collections.create!(params)
        else
          resource = collections.first
          resource.update_attributes!(params)
        end
      end
    end
  end

  def cardno_long
    if self.nickname == nil
      self.cardno
    else
     self.cardno + " (" + self.nickname + ")"
   end
  end

  class << self

    def used_source_per_period(query)
      collection = CardUsedSource.where('approved_at IS NOT NULL').order(query)
      if collection.empty?
        Time.zone.now
      else
        collection.first.approved_at
      end
    end

    def newest_used_source
      used_source_per_period('approved_at DESC')
    end

    def oldest_used_source
      used_source_per_period('approved_at ASC') - 1.month
    end
  end
end
