module DayworkersHelper
  def options_for_dayworkers_select(dayworker_tax)
    id = dayworker_tax.dayworker ? dayworker_tax.dayworker.id : nil
    collection = Dayworker.all.map do |dayworker|
      contact = dayworker.person.contact
      if contact
        description = "#{contact.name} - "
      end

      description += dayworker.juminno
      [description, dayworker.id]
    end

    options_for_select(collection, id)
  end
end