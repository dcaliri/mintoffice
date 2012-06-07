class CardUsedSource < ActiveRecord::Base
  belongs_to :creditcard

  self.per_page = 20

  before_save :strip_approve_no
  def strip_approve_no
    approve_no.strip!
  end

  include ResourceExportable
  resource_exportable_configure do |config|
    config.except_column 'creditcard_id'
    config.period_subtitle :approved_at
  end

  class << self
    def search(text)
      text = "%#{text}%"
      where('bank_name like ? OR card_holder_name like ? OR approve_no like ? OR money_krw like ? OR store_name like ?', text, text, text, text, text)
    end

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