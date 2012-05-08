class UsedVacationsController < ApplicationController
  def redirect_unless_permission
  end

  expose(:vacation)
  expose(:used_vacations) { vacation.used }
  expose(:used_vacation)

  expose(:user) { vacation.user }

  def create
    used_vacation.save!
    Boxcar.send_to_boxcar_group("admin",used_vacation.vacation.user.name, "Used Vacation")
    redirect_to [user, vacation]
  end

  def update
    used_vacation.save!
    Boxcar.send_to_boxcar_group("admin",used_vacation.vacation.user.name, "Used Vacation")
    redirect_to [user, vacation]
  end

  def approve
    used_vacation.approve = params[:approve]
    used_vacation.save
    redirect_to [user, vacation]
  end

  def destroy
    used_vacation.destroy
    redirect_to [user, :vacations]
  end
end