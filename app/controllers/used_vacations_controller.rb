class UsedVacationsController < ApplicationController
  def redirect_unless_permission
  end

  expose(:vacation)
  expose(:used_vacations) { vacation.used }
  expose(:used_vacation)

  expose(:user) { vacation.user }

  def create
    used_vacation.save!
    redirect_to [user, :vacations]
  end

  def update
    used_vacation.save!
    redirect_to [user, :vacations]
  end

  def approve
    used_vacation.approve = params[:approve]
    used_vacation.save
    
    redirect_to [user, :vacations]
  end

  def destroy
    used_vacation.destroy
    redirect_to [user, :vacations]
  end
end