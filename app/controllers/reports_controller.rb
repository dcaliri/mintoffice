#encoding: UTF-8

class ReportsController < ApplicationController
  skip_before_filter :authorize, only: [:report]

  def report
    report_target_class = params[:target_type].constantize
    report_target = report_target_class.find(params[:target_id])
    report_url = url_for(report_target.redirect_when_reported)

    case params[:commit]
    when "상신"
      user = User.find(params[:reporter]) if params[:reporter]
      report_target.report!(user, params[:comment], report_url)
    when "승인"
      report_target.approve!(params[:comment])
    when "반려"
      report_target.rollback!(params[:comment], report_url)
    end

    redirect_to report_target.redirect_when_reported
  end
end