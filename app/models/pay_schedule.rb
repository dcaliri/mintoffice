class PaySchedule < ActiveRecord::Base
  belongs_to :user

  def basic_pay
    unless income
      0
    else
      (income * ((100 - total_bonus) / 100.0)) / 12
    end
  end

  def pay_per_month(month)
     basic_pay * ((100 + send(Date::MONTHNAMES[month])) / 100.0)
  end

  def total_bonus
    (1..12).sum do |month|
      bonus = send(Date::MONTHNAMES[month])
      unless bonus.nil? then bonus else 0 end
    end
  end
end