class CardUsedSource < ActiveRecord::Base
  belongs_to :creditcard

  self.per_page = 20

  before_save :strip_approve_no
  def strip_approve_no
    approve_no.strip!
  end

  class << self
    def group_by_name_anx_tax
      all.group_by{|cards| cards.bank_name }.map do |name, cards|
        {name: name, tax: cards.sum{|card| card.tax}}
      end
    end

    def latest
      order('approved_at DESC, approved_time DESC')
    end

    def oldest_at
      resource = order('approved_at DESC').last
      if resource && resource.approved_at
        resource.approved_at
      else
        Time.zone.now
      end
    end

    def total_tax
      sum{|used| used.tax }
    end

    def total_price
      sum{|used| used.money_krw ? used.money_krw : 0 }
    end
  end
end