#encodig: UTF-8
class Creditcard < ActiveRecord::Base
  has_many :cardbills
  has_many :card_used_sources
  has_many :card_approved_sources

  has_many :change_histories, :as => :changable

  validates_presence_of :cardno
  validates_presence_of :expireyear
  validates_presence_of :expiremonth
  validates_presence_of :nickname
  validates_presence_of :issuer
  validates_presence_of :cardholder
  validates_uniqueness_of :cardno

  CARD_LIST = [:used, :approved]

  def cardno_long
    if self.nickname == nil
      self.cardno
    else
     self.cardno + " (" + self.nickname + ")"
   end
  end

  class << self
    def newest_used_source
        CardUsedSource.order('approved_at DESC').first.approved_at
    end

    def oldest_used_source
        CardUsedSource.order('approved_at ASC').first.approved_at - 1.month
    end
  end
end
