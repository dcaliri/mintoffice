class TaxbillItem < ActiveRecord::Base
  belongs_to :taxbill

  validates :quantity, :numericality => { greater_than: 0 }

  def quantity
    amount = read_attribute(:quantity)
    unless amount.nil?
      amount
    else
      0
    end
  end

  def price
    unitprice * quantity
  end
end