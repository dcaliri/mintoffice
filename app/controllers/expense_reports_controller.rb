class ExpenseReportsController < ApplicationController
  expose(:expense_report)
  before_filter :check_report_access, except: [:index, :new, :create]

  def index
    project = Project.find(params[:project_id]) unless params[:project_id].blank?
    @expenses_by_menu = ExpenseReport.filter(user: current_user)
    @expenses = ExpenseReport.filter(
                                user: current_user,
                                project: project,
                                year: params[:year].to_i,
                                month: params[:month].to_i
                              ).page(params[:page])
  end

  def create
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