class HolidaysController < ApplicationController
  expose(:holidays) { Holiday.all }
  expose(:holiday)
  # def redirect_unless_permission
  # end
  # 
  # before_filter :redirect_unless_admin, :only => :index
  # 
  # expose(:users) { User(:protected) }
  # expose(:user)
  # expose(:vacations) { user.vacations.latest }
  # expose(:vacation)
  # 
  # before_filter {|controller| controller.redirect_unless_me(user)}
  # 
  # def index
  #   @users = User(:protected).enabled.page(params[:page])
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