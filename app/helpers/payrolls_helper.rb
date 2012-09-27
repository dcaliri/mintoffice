# encoding: UTF-8

module PayrollsHelper
  def options_for_payroll_period_select(period)
    oldest_payday = Payroll.oldest.first.payday rescue nil
    latest_payday = Payroll.latest.first.payday rescue nil

    collection = [["전체", nil]]
    if oldest_payday and latest_payday
      oldest_payday = oldest_payday.beginning_of_month
      latest_payday = latest_payday.end_of_month

      date = oldest_payday.dup
      while date < latest_payday
        description = date.strftime("%Y년 %m월")
        collection << [description, date]
        date += 1.month
      end
    end

    options_for_select(collection, period)
  end
end