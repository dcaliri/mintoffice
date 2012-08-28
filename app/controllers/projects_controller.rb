class ProjectsController < ApplicationController
  before_filter :redirect_unless_my_project, except: :index

  expose(:projects) { current_company.projects }
  expose(:project)

  def index
    if current_employee.admin?
      project_list = projects
    else
      project_list = current_employee.projects
    end

    status = params[:st] || "in_progress"
    if status == 'in_progress'
      @projects = project_list.inprogress
      @status_me = I18n.t("projects.index.in_progress")
      @status_other = I18n.t("projects.index.completed")
      @st_other = 'completed'
    else
      @projects = project_list.completed
      @status_me = I18n.t("projects.index.completed")
      @status_other = I18n.t("projects.index.in_progress")
      @st_other = 'in_progress'
    end
  end

  def create
    project.save!
    redirect_to project, notice: t("common.messages.created", :model => Project.model_name.human )
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def update
    project.update_attributes!(params[:project])
    redirect_to project, notice: I18n.t("common.messages.updated", :model => Project.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def change_owner
    project.change_owner!(params[:employee_id])
    redirect_to :back
  end

  def completed
    project.ended_on = Time.now
    project.save!
    redirect_to :projects
  end

  def assign
    @employee = Employee.find(params[:employee_id])
    @projects = @employee.projects.inprogress
  end

  def assign_projects
    @employee = Employee.find(params[:employee_id])
    if projects.assign_projects(@employee, params[:projects])
      redirect_to [:assign, @employee, :projects]
    else
      redirect_to [:assign, @employee, :projects], notice: t('projects.assign.not_hundred')
    end
  end


  def add_employee
    employees = Employee.find_by_account_name(params[:accountname])
    unless employees.empty?
      employee  = employees.first
      if project.employees.include? employee
        flash[:notice] = I18n.t "common.messages.already_exist"
      else
        project.employees << employee
      end
    else
      flash[:notice] = I18n.t "common.messages.no_such_account"
    end

    redirect_to [:edit, project]
  end

  def remove_employee
    employee = Employee.find(params[:employee_id])
    project.employees.delete(employee)
    redirect_to [:edit, project]
  end

private
  def find_projects(projects)
    status = params[:st] || "in_progress"
    if status == 'in_progress'
      @projects = projects.inprogress
      @status_me = I18n.t("projects.index.in_progress")
      @status_other = I18n.t("projects.index.completed")
      @st_other = 'completed'
    else
      @projects = projects.completed
      @status_me = I18n.t("projects.index.completed")
      @status_other = I18n.t("projects.index.in_progress")
      @st_other = 'in_progress'
    end
  end

  def redirect_unless_my_project
    force_redirect unless (current_employee.admin? or current_employee.projects.exists?(project.id))
  end
end
