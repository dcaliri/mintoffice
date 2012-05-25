# encoding: UTF-8

class CardApprovedSource < ActiveRecord::Base
  belongs_to :creditcard

  self.per_page = 20

  before_save :strip_approve_no
  def strip_approve_no
    approve_no.strip!
  end

  class << self
    def by_date(date)
      if date == "all" or date.nil?
        where("")
      else
        date = Date.parse(date) if date.class == String && !date.blank?
        where(will_be_paied_at: date.to_time)
      end
    end

    def will_be_paid_at_list
      select(:will_be_paied_at).uniq.map{|source| source.will_be_paied_at.strftime("%Y-%m-%d") rescue ""}
    end

    def total_price
      sum{|used| used.money }
    end

    def search(text)
      text = "%#{text}%"
      where('approve_no like ? OR card_no like ? OR card_holder_name like ? OR store_name like ? OR money like ?', text, text, text, text, text)
    end

    def find_empty_cardbill
      if Cardbill.all.empty?
        where("")
      else
        where('approve_no not in (?)', Cardbill.all.map{|cardbill| cardbill.approveno})
      end.no_canceled
    end

    def no_canceled
      where('status != ?', "승인취소")
    end

    def generate_cardbill
      total_count = 0
      no_canceled.find_each do |approved_source|
        next if Cardbill.exists?(approveno: approved_source.approve_no)

        used_sources = CardUsedSource.where(approve_no: approved_source.approve_no)
        next if used_sources.empty?
        used_source = used_sources.first

        approved_source.creditcard.cardbills.create!(
          amount: used_source.price,
          servicecharge: used_source.tax,
          vat: used_source.tip,
          approveno: approved_source.approve_no,
          totalamount: approved_source.money,
          transdate: approved_source.used_at,
          storename: approved_source.store_name,
          storeaddr: used_source.store_addr1 + " " + used_source.store_addr2,
        )
        total_count += 1
      end
      total_count
    end
  end

  def cardbill
    collection = Cardbill.where(approveno: approve_no)
    collection.first unless collection.empty?
  end

  def used_at_to_s
    attribute = read_attribute(:used_at)
    attribute.blank? ? "" : attribute.strftime("%Y.%m.%d %H:%M")
  end

  def canceled_at_to_s
    attribute = read_attribute(:canceled_at)
    attribute.blank? ? "" : attribute.strftime("%Y %m.%d")
  end

  def will_be_paied_at_to_s
    attribute = read_attribute(:will_be_paied_at)
    attribute.blank? ? "" : attribute.strftime("%Y %m.%d")
  end

  def self.latest
    order("used_at DESC")
  end
end