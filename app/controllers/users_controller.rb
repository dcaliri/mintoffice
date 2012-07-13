# encoding: UTF-8

class UsersController < ApplicationController
  layout "application", :except => [:login]
  layout "login", only: [:login]

  before_filter :only => [:show] do |c|
    @this_user = User.find(params[:id])
    c.save_attachment_id @this_user
  end

  before_filter :except => [:my, :changepw, :login, :edit, :update, :logout, :google_apps] do |c|
    unless @user.admin?
      flash[:notice] = I18n.t("common.messages.not_allowed")
      redirect_to :controller => "main", :action => "index"
      return
    end
  end

  def index
    @users = User.check_disabled(params[:disabled]).search(params[:q]).order(:id)
  end

  def logout
    session[:user_id] = nil
    redirect_to(:controller => "main", :action => "index")
  end

  def login
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        session[:user_id] = user.id
        redirect_to(:controller => "main", :action => "index")
      else
        flash.now[:notice] = t("users.login.loginfail")
      end
    end
  end

  def disable
    @this_user = User.find(params[:id])
    @this_user.disable
    redirect_to :action => "index"
  end

  def new
    @this_user = User.new
  end

  def edit
    @this_user = User.find(params[:id])
  end

  def create
    @this_user = User.new(params[:user])
    @this_user.companies << current_company
    if @this_user.save
      Boxcar.add_to_boxcar(@this_user.boxcar_account) unless @this_user.boxcar_account.empty?
      flash[:notice] = I18n.t("common.messages.created", :model => User.model_name.human)
      redirect_to :action => 'index'
    else
      render :action => "new"
    end
  end

  def update
    @this_user = User.find(params[:id])

    if @this_user.update_attributes(params[:user])
      logger.info @this_user.changes
      Boxcar.add_to_boxcar(@this_user.boxcar_account) if ! @this_user.boxcar_account.empty?

      flash[:notice] = I18n.t("common.messages.updated", :model => User.model_name.human)
      if @this_user.admin?
        redirect_to user_path(@this_user)
      else
        redirect_to [:users, :my]
      end
    else
      render :action => "edit"
    end
  end

  def google_apps
    @users = User.has_google_apps_account
  end

  def create_google_apps
    @this_user = User.find(params[:id])
    if @this_user.create_google_app_account
      redirect_to :back, notice: t('controllers.users.create_google')
    else
      redirect_to :back, alert: t('controllers.users.fail_create_google')
    end
  end

  def remove_google_apps
    @this_user = User.find(params[:id])
    if @this_user.remove_google_app_account
      redirect_to :back, notice: t('controllers.users.remove_google')
    else
      redirect_to :back, alert: t('controllers.users.fail_remove_google')
    end
  end

  def create_redmine
    @this_user = User.find(params[:id])
    redmine = @this_user.create_redmine_account
    redirect_to :back, notice: t('controllers.users.create_redmine')
  rescue => e
    logger.info "created_redmine failed: #{e.message}"
    redirect_to :back, alert: t('controllers.users.fail_create_redmine', message: e.message)
  end

  def remove_redmine
    @this_user = User.find(params[:id])
    @this_user.remove_redmine_account
    redirect_to :back, notice: t('controllers.users.remove_redmine')
  rescue => e
    logger.info "remove_redmine failed: #{e.message}"
    redirect_to :back, alert: t('controllers.users.fail_remove_redmine', message: e.message)
  end

  def changepw
    if request.post?
      this_user = User.find(params[:user_id])
      if  params[:password] != params[:password_confirmation]
         flash.now[:notice] = I18n.t("users.changepw.password_confirm_wrong")
       end
       unless flash.now[:notice]
         this_user.password = params[:password]
         this_user.save
         flash[:notice] = I18n.t("users.changepw.successfully_changed")
         if @user.ingroup? "admin"
           redirect_to(:action => "index")
         else
           redirect_to users_my_path()
         end
       end
     end
  end

  def loginas
    target_user = User.find(params[:id])
    session[:user_id] = target_user.id
    redirect_to(:controller => "main", :action => "index")
  end
end
