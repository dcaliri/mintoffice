class PayrollsController < ApplicationController
  def redirect_unless_permission
  end
  
  expose (:payrolls) {Payroll.all}
  expose (:payroll)
  expose (:users) {User(:protected).enabled}
  expose (:hrinfos) {Hrinfo.not_retired}

  def create
    payroll.save!
    redirect_to [:payrolls]
  end
  
  def update
    payroll.save!
    redirect_to [:payroll]
  end
  
end