class VacationsController < ApplicationController
  def redirect_unless_permission
  end

  expose(:users) { User(:protected).page(params[:page]) }
  expose(:user)
  expose(:vacations) { user.vacations.latest }
  expose(:vacation)

  def create
    vacation.save!
    redirect_to [user, :vacations]
  end

  def update
    vacation.save!
    redirect_to [user, :vacations]
  end

  def destroy
    vacation.destroy
    redirect_to [user, :vacations]
  end
end