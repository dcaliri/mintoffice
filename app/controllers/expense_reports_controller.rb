class ExpenseReportsController < ApplicationController
  expose(:expense_report)
  before_filter :check_report_access, except: [:index, :new, :create]

  def index
    @expenses = ExpenseReport.access_list(current_user).page(params[:page])
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