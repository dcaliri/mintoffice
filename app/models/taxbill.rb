# encoding: UTF-8

class Taxbill < ActiveRecord::Base
  belongs_to :taxman
  has_many :items, :class_name => 'TaxbillItem', :dependent => :destroy

  BILL_TYPE = [:purchase, :sale]

  def self.taxmen_list
    Taxman.all.map do |taxman|
      ["#{taxman.fullname} / #{taxman.business_client.name}", taxman.id]
    end
  end

  def price
    items.sum{|item| item.unitprice }
  end

  def tax
    items.sum{|item| item.tax }
  end

  def total
    items.sum{|item| item.total }
  end
end