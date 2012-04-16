class PaySchedulesController < ApplicationController
  expose(:user)
  expose(:pay_schedules) { user.pay_schedules }
  expose(:pay_schedule)

  def create
    pay_schedule.save!
    redirect_to payment_path(user)
  end

  def update
    pay_schedule.save!
    redirect_to payment_path(user)
  end

  def destroy
    pay_schedule.destroy
    redirect_to payment_path(user)
  end
end