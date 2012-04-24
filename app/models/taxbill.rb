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

  def self.purchases
    where(billtype: "purchase")
  end

  def self.sales
    where(billtype: "sale")
  end

  def self.oldest_at
    resource = order('transacted_at DESC').last
    if resource && resource.transacted_at
      resource.transacted_at
    else
      Time.zone.now
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

  def self.total_tax
    sum{|taxbill| taxbill.tax }
  end

  class << self
    def search(params)
      text_search(params[:query]).billtype(params[:billtype]).taxmen(params[:taxman_id])
    end

    def text_search(text)
      text = "%#{text || ""}%"
      includes(:taxman).where('taxmen.fullname like ?', text)
    end

    def billtype(text)
      if text == "all" or text == nil
        where("")
      else
        where(billtype: text)
      end
    end

    def taxmen(text)
      if text == "0" or text == nil
        where("")
      else
        where(taxman_id: text)
      end
    end

    def latest
      order("transacted_at DESC")
    end
  end
end