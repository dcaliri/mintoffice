class ReportsController < ApplicationController
  before_filter :report_access

  def report
    cardbill = Cardbill.find(params[:cardbill_id])
    hrinfo = Hrinfo.find(params[:report][:reporter]) if params[:report]
    unless current_user.ingroup?(:admin)
      cardbill.report!(hrinfo)
    else
      cardbill.approve!
    end
    redirect_to cardbill
  end

  def report_access
    cardbill = Cardbill.find(params[:cardbill_id])
  end
end