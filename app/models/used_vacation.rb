#encoding: UTF-8

class UsedVacation < ActiveRecord::Base
  belongs_to :vacation
  validate :valid_period

  include Historiable
  def history_parent
    vacation
  end

  include Reportable
  def redirect_when_reported
    [vacation, self]
  end

  def valid_period
    errors.add(:period, "1 or 0.5") unless period - period.to_i == 0 || period - period.to_i == 0.5
  end

  def self.total
    all.sum {|vacation| vacation.period || 0}
  end

  def self.during(range)
    where("(`used_vacations`.`from` > ? AND `used_vacations`.`from` < ? ) OR \
          (`used_vacations`.`to` > ? AND `used_vacations`.`to` < ? ) OR \
          (`used_vacations`.`from` < ? AND `used_vacations`.`to` > ?)",
      range.begin.to_date, range.end.to_date, range.begin.to_date, range.end.to_date, range.begin.to_date, range.end.to_date)
  end

  def in? (day)
    self.from <=  day && self.to >= day
  end
end
