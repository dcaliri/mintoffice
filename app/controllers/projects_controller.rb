class ProjectsController < ApplicationController
  expose(:projects) { current_company.projects }
  expose(:project)

  def index
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

  def completed
    project.ended_on = Time.now
    project.save!
    redirect_to :projects
  end

  def assign
    @this_user = User.find(params[:user_id])
    @projects = @this_user.hrinfo.projects.inprogress
  end

  def assign_projects
    @this_user = User.find(params[:user_id])
    if projects.assign_projects(@this_user, params[:projects])
      redirect_to [:assign, @this_user, :projects]
    else
      redirect_to [:assign, @this_user, :projects], notice: t('projects.assign.not_hundred')
    end
  end


  def add_user
    user = User.find_by_name(params[:username])
    if user
      if project.hrinfos.include? user.hrinfo
        flash[:notice] = I18n.t "common.messages.already_exist"
      else
        project.hrinfos << user.hrinfo
      end
    else
      flash[:notice] = I18n.t "common.messages.no_such_user"
    end

    redirect_to [:edit, project]
  end

  def del_user
    # user = User.find(params[:uid])
    # project.users.delete(user)
    # redirect_to [:edit, project]
    hrinfo = Hrinfo.find(params[:uid])
    project.hrinfos.delete(hrinfo)
    redirect_to [:edit, project]
  end
end
