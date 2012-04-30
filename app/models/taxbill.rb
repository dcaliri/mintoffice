# encoding: UTF-8

class Taxbill < ActiveRecord::Base
  belongs_to :taxman
  belongs_to :business_client
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

  class << self
    def taxmen_list
      Taxman.all.map do |taxman|
        ["#{taxman.fullname} / #{taxman.business_client.name}", taxman.id]
      end
    end

    def purchases
      where(billtype: "purchase")
    end

    def sales
      where(billtype: "sale")
    end

    def oldest_at
      resource = order('transacted_at DESC').last
      if resource && resource.transacted_at
        resource.transacted_at
      else
        Time.zone.now
      end
    end

    def total_tax
      sum{|taxbill| taxbill.tax }
    end

    def group_by_name_anx_tax
      all.group_by do |purchase|
        if purchase.taxman and purchase.taxman.business_client
          purchase.taxman.business_client.name
        else
          "기타"
        end
      end.map do |name, purchases|
        {name: name, tax: purchases.sum{|p| p.tax}, price: purchases.sum{|p| p.price}}
      end
    end

    def search(params)
      billtype(params[:billtype]) || taxmen(params[:taxman_id])
#      text_search(params[:query]) || billtype(params[:billtype]) || taxmen(params[:taxman_id])
    end

    def text_search(text)
      text = "%#{text || ""}%"
      joins(:taxman).where('taxmen.fullname like ?', text)
#      joins(:taxman).merge(Taxman.where("fullname like ?", text))
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