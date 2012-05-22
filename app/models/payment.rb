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

  def self.by_month(period)
    where(pay_at: (period..period.end_of_month))
  end

  def self.pay_from(period)
    where('pay_at > ?', period)
  end

  def retired_amount(from)
    remain = (pay_at - from).day
    if payment_type != 'default' or remain > 1.month
      0
    else
      working_day = Holiday.working_days(from, pay_at)
      (latest_default_payment(from) / working_day.to_f).to_i
    end
  end

  def retired!(from)
    self.amount = retired_amount(from)
    if self.amount == 0
      destroy
    else
      save!
    end
  end

  def latest_default_payment(from)
    user.payments.latest.each_cons(2) do |after, before|
      return after.amount if after.pay_at == before.pay_at.next_month
    end
  end

  def self.basic_payment(payments)
    total = payments["total"].to_i
    after = payments["after"]
    total * ((100 - total_bonus(after)) / 100.0) / 12
  end

  def self.create_yearly!(payments)
    payments.each do |after|
      pay_at = Time.zone.parse(after[0])

      ["default", "bonus"].each do |type|
        pay_info = after[1][type]
        title = pay_info["title"]
        amount = pay_info["amount"].to_i

        create!(payment_type: type, :note => title, :pay_at => pay_at, :amount => amount) if amount > 0
      end
    end
  end

  def self.latest
    order('pay_at DESC')
  end
end