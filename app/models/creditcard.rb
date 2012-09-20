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
    def history_per_period(query)
      collection = CardHistory.where('paid_at IS NOT NULL').order(query)
      if collection.empty?
        Time.zone.now
      else
        collection.first.paid_at
      end
    end

    def newest_history_source
      history_per_period('paid_at DESC')
    end

    def oldest_history_source
      history_per_period('paid_at ASC') - 1.month
    end
  end
end
