#encoding: UTF-8
class Event
  attr_accessor :title, :start_time, :used
end

class UsedVacation < ActiveRecord::Base
  belongs_to :vacation

  has_many :vacation_type_infos
  has_many :vacation_types, through: :vacation_type_infos

  validate :valid_period
  scope :latest, order('`from` DESC')

  attr_accessor :type_
  before_save :save_vacation_type, :calculate_period
  def save_vacation_type
    if type_
      type = VacationType.find(type_)
      self.vacation_types.clear
      self.vacation_types << type
    end
  end

  def calculate_period
    self.period = (self.type.deductible? ? 1 : 0 )* (events.size - (self.from_half == 'PM' ? 0.5 : 0) - (self.to_half == 'AM' ? 0.5 : 0))
  end

  def title
    (self.type.nil? or self.vacation.nil?) ? "" : "#{self.type.title} : #{self.vacation.employee.fullname}"
  end

  def start_time
    from
  end

  def events
    day = from
    events = []
    loop do
      event = Event.new
      event.title = title
      event.start_time = day
      event.used = self
      if Holiday.during(day..day).empty? and ! day.saturday? and ! day.sunday?
        events << event
      end
      day += 1.day
      break unless day <= to
    end
    events
  end

  include Historiable
  def history_parent
    vacation
  end

  def summary
    username = report.reporter.prev.fullname rescue ""
    vacation_type = type.title rescue ""
    
    "[연차] #{username}님이 #{vacation_type}으로 연차를 신청하였습니다. (기간 : #{from} ~ #{to}, 사유 : #{note} )"
  end

  include Reportable
  def redirect_when_reported
    [vacation, self]
  end

  def valid_period
    puts "-----"
    puts period
    puts "-----"
    errors.add(:period, "1 or 0.5") unless period - period.to_i == 0 || period - period.to_i == 0.5
  end

  def self.total
    report_status(:reported).sum {|vacation| vacation.period || 0}
  end

  def self.during(range)
    where("(`used_vacations`.`from` >= ? AND `used_vacations`.`from` <= ? ) OR \
          (`used_vacations`.`to` >= ? AND `used_vacations`.`to` <= ? ) OR \
          (`used_vacations`.`from` <= ? AND `used_vacations`.`to` >= ?)",
      range.begin.to_date, range.end.to_date, range.begin.to_date, range.end.to_date, range.begin.to_date, range.end.to_date)
  end

  def type
    vacation_types.first
  end

  def type_title
    type.title rescue ""
  end

  def type_id
    type.id rescue nil
  end

  def in? (day)
    self.from <= day && self.to >= day
  end
end
