class AnnualPaySchedulesController < ApplicationController
  expose(:user)
  expose(:annual_pay_schedules) { user.annual_pay_schedules }
  expose(:annual_pay_schedule)


  def create
    annual_pay_schedule.save!
    redirect_to payment_path(user)
  end

  def update
    annual_pay_schedule.save!
    redirect_to payment_path(user)
  end

  def destroy
    annual_pay_schedule.destroy
    redirect_to payment_path(user)
  end
end