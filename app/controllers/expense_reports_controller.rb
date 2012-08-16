class ExpenseReportsController < ApplicationController
  expose(:expense_report)
  before_filter :access_check, except: [:index, :no_permission, :new, :create]

  def index
    project = Project.find(params[:project_id]) unless params[:project_id].blank?
    @expenses_by_menu = ExpenseReport.filter(person: current_person)
    @expenses = ExpenseReport.filter(
                                person: current_person,
                                project: project,
                                year: params[:year].to_i,
                                month: params[:month].to_i,
                                empty_permission: params[:empty_permission]
                              )
                              .report_status(params[:report_status])
                              .page(params[:page])
  end

  def create
    expense_report.employee = current_employee
    expense_report.save!
    expense_report.add_permission_of_project_owner
    redirect_to expense_report
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def update
    expense_report.save!
    redirect_to expense_report
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    expense_report.destroy
    redirect_to :expense_reports
  end
end