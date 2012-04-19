# encoding: UTF-8

class Taxbill < ActiveRecord::Base
  belongs_to :taxman
  belongs_to :attachment
  has_many :items, :class_name => 'TaxbillItem', :dependent => :destroy

  BILL_TYPE = [:purchase, :sale]

  def self.taxmen_list
    Taxman.all.map do |taxman|
      ["#{taxman.fullname} / #{taxman.business_client.name}", taxman.id]
    end
  end

  def price
    items.sum{|item| item.price }
  end

  def tax
    items.sum{|item| item.tax }
  end

  def total
    items.sum{|item| item.total }
  end

  def self.search(text)
    text = "%#{text || ""}%"
    includes(:taxman).where('taxmen.fullname like ?', text)
  end
  
  def self.seachbybilltype(text)
    if text == "all" or text == nil
      where("1 IS 1")
    else
      where("billtype is ?", text)
    end
  end
  
  def self.searchbytaxman(text)
    if text == "0" or text == nil
      where("1 IS 1")
    else
      where("taxman_id is ?",text)
    end
  end
end