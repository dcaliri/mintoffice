#encoding: UTF-8

class Payment < ActiveRecord::Base
  # belongs_to :user
  belongs_to :hrinfo

  before_save :modify_bonus_date
  def modify_bonus_date
    self.pay_start = self.pay_finish if self.payment_type == 'bonus'
  end

  include Historiable
  def history_info
    Hash[attributes.keys.collect do |key|
      {key.to_sym => proc { |payment, v| "[#{payment.pay_finish}]#{v}" }}
    end.flatten]
  end

  def self.payment_in?(from, to)
#    where('pay_finish ? AND amount > ?', from..to, 0)
#    where('sum(amount) > 0 AND pay_finish BETWEEN ? AND ?', from, to).group("date(pay_finish)")
    where(pay_finish: from..to)
  end
  def self.total_bonus(bonuses)
    bonuses.sum {|after| after[1].to_i }
  end

  def self.total
    sum{|payment| payment.amount}
  end

  def self.by_month(period)
    where(pay_finish: (period..period.end_of_month))
  end

  def self.pay_from(period)
    where('pay_finish > ?', period)
  end

  def retired_amount(from)
    remain = (pay_finish - from).day

    (-self.amount) + if payment_type == 'default' or remain < 1.month
                       working_day = Holiday.working_days(pay_start, from)
                       working_month = Holiday.working_days(pay_start, pay_finish)
                       ((self.amount / working_month.to_f) * working_day.to_f).to_i
                     else
                       0
                     end
  end

  def self.retire!(retired_on)
    pay_from(retired_on).find_each do |payment|
      new_payment = payment.dup
      new_payment.amount = payment.retired_amount(retired_on)
      new_payment.save!
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

  def self.basic_payment(payments)
    total = payments["total"].to_i
    after = payments["after"]
    total * ((100 - total_bonus(after)) / 100.0) / 12
  end

  def self.create_yearly!(payments)
    payments.each do |after|
      period = after[0].split(" ~ ")
      pay_start = Time.zone.parse(period.first)
      pay_finish = Time.zone.parse(period.last)

      ["default", "bonus"].each do |type|
        pay_info = after[1][type]
        title = pay_info["title"]
        amount = pay_info["amount"].to_i

        create!(payment_type: type,
                note: title,
                pay_start: type == 'default' ? pay_start : pay_finish,
                pay_finish: pay_finish,
                amount: amount) if amount > 0
      end
    end
  end

  def self.latest
    order('pay_finish DESC')
  end
end