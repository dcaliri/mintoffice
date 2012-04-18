class VacationsController < ApplicationController
  def redirect_unless_permission
  end

  expose(:user)
  expose(:vacations) { user.vacations.latest }
  expose(:vacation)

  def create
    vacation.save!
    redirect_to vacation_path(user)
  end

  def update
    vacation.save!
    redirect_to vacation_path(user)
  end

  def destroy
    vacation.destroy
    redirect_to vacation_path(user)
  end
end