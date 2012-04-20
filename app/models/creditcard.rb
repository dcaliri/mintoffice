class Creditcard < ActiveRecord::Base
  has_many :cardbills
  has_many :card_used_sources

  validates_presence_of :cardno
  validates_presence_of :expireyear
  validates_presence_of :expiremonth
  validates_presence_of :nickname
  validates_presence_of :issuer
  validates_presence_of :cardholder
  validates_uniqueness_of :cardno

  def cardno_long
    if self.nickname == nil
      self.cardno
    else
     self.cardno + " (" + self.nickname + ")"
   end
  end
end
