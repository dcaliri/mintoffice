class TaxbillItem < ActiveRecord::Base
  belongs_to :taxbill

  validates :quantity, :numericality => { greater_than: 0 }
end