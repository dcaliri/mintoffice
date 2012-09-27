class PayrollsController < ApplicationController
  def redirect_unless_permission; end

  expose (:payroll)
  expose (:accounts) {Account(:protected).enabled}
  expose (:employees) {Employee.not_retired}

  def index
    period = Date.parse(params[:period]) if params[:period].present?
    @payrolls = Payroll.by_period(period)
  end

  def create
    payroll.save!
    redirect_to [:payrolls]
  end

  def update
    payroll.save!
    redirect_to [:payroll]
  end
end