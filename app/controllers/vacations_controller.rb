class VacationsController < ApplicationController
  expose(:user)
  expose(:vacations) { user.vacations }
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