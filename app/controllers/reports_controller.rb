#encoding: UTF-8

class ReportsController < ApplicationController
  def report
    report_target_class = params[:target_type].constantize
    report_target = report_target_class.find(params[:target_id])
    redirect_to_index = report_target_class.to_s.tableize.to_sym

    report = report_target.report
    case params[:commit]
    when "상신"
      user = User.find(params[:reporter]) if params[:reporter]
      report.report!(user, params[:comment])
      redirect_to redirect_to_index
    when "승인"
      report.approve!(params[:comment])
      redirect_to report_target
    when "반려"
      report.rollback!(params[:comment])
      redirect_to redirect_to_index
    end
  end
end