class VacationsController < ApplicationController
  def redirect_unless_permission
  end

  before_filter :redirect_unless_admin, :only => :index

  expose(:users) { User(:protected) }
  expose(:user)
  expose(:vacations) { user.vacations.latest }
  expose(:vacation)

  before_filter {|controller| controller.redirect_unless_me(user)}
  before_filter :only_admin_access_vacation, :except => [:index, :show]

  def index
    @users = User(:protected).enabled.page(params[:page])
  end

  def create
    vacation.save!
    redirect_to [user, vacation]
  end

  def update
    vacation.save!
    redirect_to [user, vacation]
  end

  def destroy
    vacation.destroy
    redirect_to [user, vacation]
  end

  def only_admin_access_vacation
    force_redirect if !current_user.admin?
  end
end