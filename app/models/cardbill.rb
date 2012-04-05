class Cardbill < ActiveRecord::Base
  belongs_to :attachment
  belongs_to :creditcard

  # validates_presence_of :cardno
  validates_presence_of :totalamount
  validates_presence_of :approveno
  validates_numericality_of :totalamount
  validates_numericality_of :amount
  validates_numericality_of :servicecharge
  validates_numericality_of :vat
  
  def cardno_long
    unless self.creditcard.nil?
      self.creditcard.cardno_long
    else
      cardno    
    end
  end
end
