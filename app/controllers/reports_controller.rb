#encoding: UTF-8

class ReportsController < ApplicationController
  def report
    report_target_class = params[:target_type].constantize
    report_target = report_target_class.find(params[:target_id])

    case params[:commit]
    when "상신"
      user = User.find(params[:reporter]) if params[:reporter]
      report_target.report!(user, params[:comment])
    when "승인"
      report_target.approve!(params[:comment])
    when "반려"
      report_target.rollback!(params[:comment])
    end

    redirect_to report_target.redirect_when_reported
  end
end