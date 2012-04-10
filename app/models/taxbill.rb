class Taxbill < ActiveRecord::Base
  belongs_to :taxman
  has_many :taxbill_items, :dependent => :destroy

  BILL_TYPE = [:purchase, :sale]
  def price
    100
  end

  def tax
    10
  end

  def total
    90
  end
end