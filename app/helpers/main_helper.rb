module MainHelper
  def holiday? (holidays, today)
    (! holidays.empty? || today.saturday? || today.sunday?)
  end
  
  def today_css day
    'today' if (Date.today.to_date == day)
  end
  
  def holiday_css holidays, day
    'holiday' if holiday? holidays, day
  end
end
