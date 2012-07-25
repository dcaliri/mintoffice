class VacationsController < ApplicationController
  def redirect_unless_permission
  end

  before_filter :redirect_unless_admin, :only => :index

  expose(:accounts) { Account(:protected) }
  expose(:account)
  expose(:vacations) { account.hrinfo.vacations.latest }
  expose(:vacation)

  before_filter {|controller| controller.redirect_unless_me(account)}
  before_filter :only_admin_access_vacation, :except => [:index, :show]

  def index
    @accounts = Account(:protected).enabled.page(params[:page])
  end

  def create
    vacation.save!
    redirect_to [account, vacation]
  end

  def update
    vacation.save!
    redirect_to [account, vacation]
  end

  def destroy
    vacation.destroy
    redirect_to [account, vacation]
  end

  def only_admin_access_vacation
    force_redirect if !current_account.admin?
  end
end