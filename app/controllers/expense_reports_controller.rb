class ExpenseReportsController < ApplicationController
  expose(:expense_report)
  before_filter :access_check, except: [:index, :no_permission, :new, :create]

  def index
    project = Project.find(params[:project_id]) unless params[:project_id].blank?
    @expenses_by_menu = ExpenseReport.filter(account: current_account)
    @expenses = ExpenseReport.filter(
                                account: current_account,
                                project: project,
                                year: params[:year].to_i,
                                month: params[:month].to_i,
                                empty_permission: params[:empty_permission]
                              )
                              .report_status(params[:report_status])
                              .page(params[:page])
  end

  def no_permission
    @expenses_by_menu = ExpenseReport.filter(account: current_account)
    @expenses = ExpenseReport.no_permission.page(params[:page])
    render 'index'
  end

  def create
    expense_report.employee = current_account.employee
    expense_report.save!
    redirect_to expense_report
  end

  def update
    expense_report.save!
    redirect_to expense_report
  end

  def destroy
    expense_report.destroy
    redirect_to :expense_reports
  end
end