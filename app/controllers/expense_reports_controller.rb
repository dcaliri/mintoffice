class ExpenseReportsController < ApplicationController
  expose(:expense_report)

  def index
    @expenses = ExpenseReport.page(params[:page])
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