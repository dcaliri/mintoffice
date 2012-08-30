class PayrollItemsController < ApplicationController
  def redirect_unless_permission; end

  expose (:payroll_item)
  expose (:payroll)
  expose (:payroll_category) {PayrollCategory.all}

  def create
    payroll_item.payroll = payroll
    payroll_item.save!
    redirect_to payroll_path(payroll)
  end

  def update
    # payroll_item.payroll = payroll
    payroll_item.save!
    redirect_to payroll_path(payroll)
  end

end