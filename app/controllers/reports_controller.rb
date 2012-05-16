#encoding: UTF-8

class ReportsController < ApplicationController
  def report
    cardbill = Cardbill.find(params[:cardbill_id])
    report = cardbill.report
    case params[:commit]
    when "상신"
      hrinfo = Hrinfo.find(params[:reporter]) if params[:reporter]
      report.report!(hrinfo, params[:comment])
      redirect_to :cardbills
    when "승인"
      report.approve!(params[:comment])
      redirect_to cardbill
    when "반려"
      report.rollback!(params[:comment])
      redirect_to :cardbills
    end
  end
end