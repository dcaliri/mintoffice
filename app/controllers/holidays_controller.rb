class HolidaysController < ApplicationController
  expose(:holidays) { Holiday.order("theday DESC") }
  expose(:holiday)

  def create
    holiday.save!
    redirect_to holiday_path(holiday)
  end

  def update
    holiday.save!
    redirect_to holiday_path(holiday)
  end

  def destroy
    holiday.destroy
    redirect_to holidays_path
  end
end