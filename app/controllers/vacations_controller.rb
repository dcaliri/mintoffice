class VacationsController < ApplicationController
  def redirect_unless_permission
  end

  expose(:users) { User(:protected) }
  expose(:user)
  expose(:vacations) { user.vacations.latest }
  expose(:vacation)

  def index
    @users = User(:protected).enabled.page(params[:page])
  end

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