#encoding: UTF-8

class ReportsController < ApplicationController
  skip_before_filter :authorize, only: [:report]

  def report
    report_target_class = params[:target_type].constantize
    report_target = report_target_class.find(params[:target_id])
    report_url = url_for(report_target.redirect_when_reported)

    if params[:report]
      user = User.find(params[:reporter]) if params[:reporter]
      report_target.report!(user, params[:comment], report_url)
    elsif params[:approve]
      report_target.approve!(params[:comment])
    elsif params[:rollback]
      report_target.rollback!(params[:comment], report_url)
    else
      raise NoMethodError, "There is no report action"
    end

    redirect_to report_target.redirect_when_reported
    # redirect_to :back
  end
end