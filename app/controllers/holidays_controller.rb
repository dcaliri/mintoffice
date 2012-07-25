class HolidaysController < ApplicationController
  expose(:holidays) { Holiday.order("theday DESC") }
  expose(:holiday)
  # def redirect_unless_permission
  # end
  # 
  # before_filter :redirect_unless_admin, :only => :index
  # 
  # expose(:accounts) { Account(:protected) }
  # expose(:account)
  # expose(:vacations) { account.vacations.latest }
  # expose(:vacation)
  # 
  # before_filter {|controller| controller.redirect_unless_me(account)}
  # 
  # def index
  #   @accounts = Account(:protected).enabled.page(params[:page])
  # end

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