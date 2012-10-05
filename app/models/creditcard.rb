#encoding: UTF-8

class Creditcard < ActiveRecord::Base
  has_many :cardbills
  has_many :card_histories
  belongs_to :bank_account

  has_many :shinhan_card_used_histories
  has_many :shinhan_card_approved_histories
  has_many :hyundai_card_used_histories
  has_many :hyundai_card_approved_histories
  has_many :oversea_card_approved_histories

  validates_presence_of :cardno
  validates_presence_of :expireyear
  validates_presence_of :expiremonth
  validates_presence_of :nickname
  validates_presence_of :issuer
  validates_presence_of :cardholder
  validates_uniqueness_of :cardno

  include Historiable
  include Attachmentable

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
