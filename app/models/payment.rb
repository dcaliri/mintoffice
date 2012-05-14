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

  def self.basic_payment(payments)
    total = payments["total"].to_i
    after = payments["after"]
    total * ((100 - total_bonus(after)) / 100.0) / 12
  end

  def self.create_yearly!(payments)
    pay_start = DateTime.new(payments["pay_start(1i)"].to_i, payments["pay_start(2i)"].to_i, payments["pay_start(3i)"].to_i)
    total = payments["total"].to_i

    payments["after"].each do |after|
      pay_at = pay_start + after[0].to_i.month
      bonus = after[1].to_i
      create!(:note => "기본급", :pay_at => pay_at, :amount => basic_payment(payments))
      create!(:note => "상여급(#{bonus}%)", :pay_at => pay_at, :amount => total * bonus / 100) if bonus > 0
    end
  end

  def self.create_new_yearly!(payments)
    payments["after"].each do |after|
      pay_at = DateTime.parse(after[0])
      amount = after[1].to_i
      create!(:note => "기본급", :pay_at => pay_at, :amount => amount)
    end
  end

  def self.latest
    order('pay_at DESC')
  end
end