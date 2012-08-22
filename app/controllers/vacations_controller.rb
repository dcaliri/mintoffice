class VacationsController < ApplicationController
  def redirect_unless_permission; end

  before_filter :redirect_unless_admin, :only => :index

  expose(:employees) { Employee(:protected) }
  expose(:employee)

  expose(:vacations) { employee.vacations.latest }
  expose(:vacation)

  before_filter {|controller| controller.redirect_unless_me(employee)}
  before_filter :only_admin_access_vacation, :except => [:index, :show]

  def index
    @employees = Employee(:protected).enabled.not_retired.page(params[:page])
  end

  def show
    if current_person.admin?
      @vacations = vacations
    else
      @vacations = vacations.include_today
    end
  end

  def create
    vacation.save!
    redirect_to [employee, vacation]
  end

  def update
    vacation.save!
    redirect_to [employee, vacation]
  end

  def destroy
    vacation.destroy
    redirect_to [employee, vacation]
  end

  def only_admin_access_vacation
    force_redirect if !current_employee.admin?
  end
end