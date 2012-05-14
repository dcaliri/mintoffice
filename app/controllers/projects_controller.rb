class ProjectsController < ApplicationController

  def assign
    @this_user = User.find(params[:user_id])
    @projects = @this_user.projects.inprogress
  end

  # GET /projects
  # GET /projects.xml
  def index
    status = params[:st] || "inprogress"

    if status == 'inprogress'
      @projects = Project.inprogress
      @status_me = I18n.t("projects.index.in_progress")
      @status_other = I18n.t("projects.index.completed")
      @st_other = 'completed'
    else
      @projects = Project.completed
      @status_me = I18n.t("projects.index.completed")
      @status_other = I18n.t("projects.index.in_progress")
      @st_other = 'inprogress'
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        flash[:notice] = t("common.messages.created", :model => Project.model_name.human )
        format.html { redirect_to(@project) }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = I18n.t("common.messages.updated", :model => Project.model_name.human)
        format.html { redirect_to(@project) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end

  def completed
    @project = Project.find(params[:id])
    @project.ended_on = Time.now
    @project.save

    redirect_to :action => "index"
  end

  def del_user
    @project = Project.find(params[:id])
    @user = User.find(params[:uid])

    @project.users.delete(@user)
    redirect_to :action => "edit", :id => @project
  end

  def add_user
    @project = Project.find(params[:id])
    @user = User.find_by_name(params[:username])

    if @user
      if @project.users.include? @user
        flash[:notice] = I18n.t "common.messages.already_exist"
      else
        @project.users << @user
      end
    else
      flash[:notice] = I18n.t "common.messages.no_such_user"
    end

    redirect_to :action => "edit", :id => @project
  end
end
