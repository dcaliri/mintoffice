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

  def self.search(query)
    query = "%#{query || ""}%"
    where('storename like ? OR storeaddr like ?', query, query)
  end
  
  def self.searchbycreditcard(query)
    if query == nil or query == ""
      where( "1 is 1" )
    else
      where("creditcard_id = ?", query)
    end
  end
end
