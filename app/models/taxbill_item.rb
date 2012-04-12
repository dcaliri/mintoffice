class TaxbillItem < ActiveRecord::Base
  belongs_to :taxbill

  validates :quantity, :numericality => { greater_than: 0 }

  def price
    unless quantity.nil?
      unitprice * quantity
    else
      0
    end
  end

  # def total
  #   read_attribute(:price)
  # end


end