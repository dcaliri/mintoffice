class AnnualPaySchedule < ActiveRecord::Base
  belongs_to :user

  def basic_pay
    # 위 상여 입력값에 의해서 자동 계산 (총 연봉 * (100% - 총 상여)) / 12
    unless income
      0
    else
      income * (100 - total_bonus) / 12
    end
  end

  def total_bonus
    (1..12).sum do |month|
      bonus = send(Date::MONTHNAMES[month])
      unless bonus.nil? then bonus else 0 end
    end
  end
end