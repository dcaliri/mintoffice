class Holiday < ActiveRecord::Base
  def self.working_days(from,to)
    count = 0
    (from..to).each do |day|
      # TODO: less query
      unless day.saturday? || day.sunday? || ! self.find_by_theday(day).nil?
        count = count + 1
      end
    end
    count
  end
end
