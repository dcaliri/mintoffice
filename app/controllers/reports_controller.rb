#encoding: UTF-8

class ReportsController < ApplicationController
  def report
    cardbill = Cardbill.find(params[:cardbill_id])
    report = cardbill.report
    case params[:commit]
    when "상신"
      hrinfo = Hrinfo.find(params[:reporter]) if params[:reporter]
      report.report!(hrinfo, params[:comment])
    when "승인"
      report.approve!(params[:comment])
    when "반려"
      report.rollback!(params[:comment])
    end
    redirect_to cardbill
  end
end