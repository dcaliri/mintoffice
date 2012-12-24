class Holiday < ActiveRecord::Base

  def title
    dayname
  end

  def start_time
    theday
  end
  
  def self.during(range)
    where(theday: range).order(:theday)
  end

  def self.working_days_this_year
    holiday_count = {}
    (1..12).each do |month|
      startday = Date.new(Date.today.year, month, 1)
      endday = startday.end_of_month
      holiday_count[month]=self.working_days(startday,endday)
    end
    return holiday_count
  end

  def self.working_days(from,to)
    count = 0
    holidays = []
    self.all.each { |d| holidays << d.theday }
    (from..to).each do |day|
      # TODO: less query
      unless day.saturday? || day.sunday? || ! holidays.index(day).nil?
        count = count + 1
      end
    end
    count
  end
end
