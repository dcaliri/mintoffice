#encoding: UTF-8

class Payment < ActiveRecord::Base
  belongs_to :user

  include Historiable
  def history_info
    Hash[attributes.keys.collect do |key|
      {key.to_sym => proc { |payment, v| "[#{payment.pay_at}]#{v}" }}
    end.flatten]
  end

  def self.total_bonus(bonuses)
    bonuses.sum {|after| after[1].to_i }
  end

  def self.total
    sum{|payment| payment.amount}
  end

  def self.by_period(period)
#    by_month(period.month, year: period.year, field: :pay_at)
    where(pay_at: period.all_month)
  end

  def self.basic_payment(payments)
    total = payments["total"].to_i
    after = payments["after"]
    total * ((100 - total_bonus(after)) / 100.0) / 12
  end

  def self.create_yearly!(payments)
    payments.each do |after|
#      pay_at = DateTime.parse(after[0])
      pay_at = Time.zone.parse(after[0])

      ["default", "bonus"].each do |type|
        pay_info = after[1][type]
        title = pay_info["title"]
        amount = pay_info["amount"].to_i

        create!(:note => title, :pay_at => pay_at, :amount => amount) if amount > 0
      end
    end
  end

  def self.latest
    order('pay_at DESC')
  end
end