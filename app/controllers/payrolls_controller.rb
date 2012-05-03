class PayrollsController < ApplicationController
  def redirect_unless_permission
  end
  
  expose (:payrolls) {Payroll.all}
  expose (:payroll)
  expose (:users) {User(:protected).enabled}

  def create
    payroll.save!
    redirect_to [:payrolls]
  end
end