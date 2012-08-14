#encoding: UTF-8

class UsedVacation < ActiveRecord::Base
  belongs_to :vacation

  has_many :vacation_type_infos
  has_many :vacation_types, through: :vacation_type_infos

  validate :valid_period

  attr_accessor :type_
  before_save :save_vacation_type
  def save_vacation_type
    if type_
      type = VacationType.find(type_)
      self.vacation_types.clear
      self.vacation_types << type
    end
  end

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

  def type
    vacation_types.first
  end

  def type_title
    type.title
  end

  def type_id
    type.id rescue nil
  end

  def in? (day)
    self.from <=  day && self.to >= day
  end
end
