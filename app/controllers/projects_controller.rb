class ProjectsController < ApplicationController
  before_filter :redirect_unless_my_project, except: :index

  expose(:projects) { current_company.projects }
  expose(:project)

  def index
    if current_person.admin?
      project_list = projects
    else
      project_list = current_employee.related_projects
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


  def add_participant
    participant_type = params[:participant_type].to_sym

    if participant_type == :user
      employee = Employee.find_by_account_name(params[:accountname])
      if employee
        unless project.add_employee(employee)
          flash[:notice] = I18n.t "common.messages.already_exist"
        end
      else
        flash[:notice] = I18n.t "common.messages.no_such_account"
      end

      redirect_to [:edit, project]
    else
      group = Group.find_by_name(params[:accountname])
      if group
        unless project.add_group(group)
          flash[:notice] = I18n.t "common.messages.already_exist"
        end
      else
        flash[:notice] = I18n.t "common.messages.no_such_account"
      end

      redirect_to [:edit, project]
    end
  end

  def remove_participant
    info = ProjectAssignInfo.where(project_id: project.id, participant_type: params[:participant_type], participant_id: params[:participant_id])
    info.destroy_all
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
    force_redirect unless (current_employee.admin? or current_employee.related_projects.exists?(project.id))
  end
end
