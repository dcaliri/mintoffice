class PayrollsController < ApplicationController
  skip_before_filter :redirect_unless_permission

  expose (:payrolls) {Payroll.all}
  expose (:payroll)
  expose (:accounts) {Account(:protected).enabled}
  expose (:employees) {Employee.not_retired}

  def create
    payroll.save!
    redirect_to [:payrolls]
  end

  def update
    payroll.save!
    redirect_to [:payroll]
  end
end