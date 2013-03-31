#encoding: UTF-8

class Payment < ActiveRecord::Base
  belongs_to :employee
  belongs_to :payroll

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

  def self.group_by_month(payday)
    all.group_by do |payment|
      finish = payment.pay_finish.dup
      if finish.day > payday
        finish += 1.month
      end
      finish.strftime("%Y.%m")
    end
  end

  def self.payment_in?(from, to)
    where(pay_finish: from..to)
  end

  def self.total_bonus(bonuses)
    bonuses.sum {|after| after[1].to_i }
  end

  def self.total
    sum{|payment| payment.amount}
  end

  def self.by_month(period)
    start = period.change(day: Company.current_company.payday - 1) - 1.month
    finish = period.change(day: Company.current_company.payday)

    where(pay_finish: (start..finish))
  end

  def self.generate_payrolls(payday)
    payments = by_month(payday)
    
    grouped = payments.group_by{|payment| payment.employee}

    basic_category = PayrollCategory.find_by_code(1001)
    bonus_category = PayrollCategory.find_by_code(1002)


    grouped.each do |employee, employees_payments|
      basic_amount = 0
      bonus_amount = 0

      payroll = employee.payrolls.build(payday: payday)
      employees_payments.each do |payment|
        next if payment.payroll or payment.amount == 0

        if payment.payment_type.to_sym == :default
          basic_amount += payment.amount
        else
          bonus_amount += payment.amount
        end
      end

      next if basic_amount == 0 and bonus_amount == 0
      next if basic_amount + bonus_amount == 0

      payroll.items.build(amount: basic_amount, payroll_category_id: basic_category.id) if basic_amount
      payroll.items.build(amount: bonus_amount, payroll_category_id: bonus_category.id) if bonus_amount

      payroll.save!
    end
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