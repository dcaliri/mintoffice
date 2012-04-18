class UsedVacationsController < ApplicationController
  expose(:user)
  expose(:vacations) { user.vacations }
  expose(:vacation)
  expose(:used_vacations) { vacation.used }
  expose(:used_vacation)

  def create
    used_vacation.save!
    redirect_to vacation_path(user)
  end

  def update
    used_vacation.save!
    redirect_to vacation_path(user)
  end

  def destroy
    used_vacation.destroy
    redirect_to vacation_path(user)
  end
end